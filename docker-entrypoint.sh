#!/bin/bash
# Script de inicio para el contenedor Docker

echo "🚀 Iniciando Sistema de Informes de Obra en Render..."

# Detectar el puerto de Render (variable $PORT)
export N8N_PORT=${PORT:-5678}
export RENDER_PORT=${PORT:-80}

# Configurar URLs según el entorno
if [ -n "$RENDER_EXTERNAL_HOSTNAME" ]; then
    export WEBHOOK_URL="https://$RENDER_EXTERNAL_HOSTNAME/webhook/informe-obra"
    echo "🌐 Entorno de producción detectado: $RENDER_EXTERNAL_HOSTNAME"
else
    export WEBHOOK_URL="http://localhost:$N8N_PORT/webhook/informe-obra"
    echo "🔧 Entorno de desarrollo detectado"
fi

echo "📡 Puerto N8N: $N8N_PORT"
echo "📡 Puerto Render: $RENDER_PORT"
echo "📬 Webhook URL: $WEBHOOK_URL"

# Verificar variables de entorno críticas
check_env_var() {
    if [ -z "${!1}" ]; then
        echo "⚠️  ADVERTENCIA: $1 no está configurada"
        return 1
    else
        echo "✅ $1 configurada"
        return 0
    fi
}

echo "🔍 Verificando configuración..."
check_env_var "GMAIL_USER"
check_env_var "GMAIL_PASSWORD"

# Configurar N8N
echo "🤖 Configurando N8N..."
export N8N_HOST="0.0.0.0"
export N8N_PROTOCOL="http"
export NODE_ENV="production"

# Función para configurar y iniciar nginx
start_nginx() {
    echo "🌐 Configurando servidor web..."
    
    # Crear configuración de nginx para servir archivos estáticos
    cat > /tmp/nginx.conf << EOF
worker_processes 1;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    sendfile on;
    keepalive_timeout 65;
    
    # Servidor para archivos estáticos
    server {
        listen 8080;
        server_name localhost;
        root /app/public;
        index index.html;
        
        # Servir archivos estáticos
        location / {
            try_files \$uri \$uri/ /index.html;
        }
        
        # Proxy para N8N API
        location /webhook/ {
            proxy_pass http://localhost:$N8N_PORT;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
        
        # Proxy para N8N Dashboard (opcional)
        location /n8n/ {
            proxy_pass http://localhost:$N8N_PORT/;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOF

    # Iniciar nginx como proceso en segundo plano
    nginx -c /tmp/nginx.conf -g "daemon off;" &
    NGINX_PID=$!
    echo "🌐 Nginx iniciado con PID: $NGINX_PID en puerto 8080"
}

# Función para iniciar N8N
start_n8n() {
    echo "⚡ Iniciando N8N en puerto $N8N_PORT..."
    
    # Configurar directorio de datos de N8N
    export N8N_USER_FOLDER=/home/node/.n8n
    
    # Configurar webhook URL base
    export WEBHOOK_URL_BASE="https://$RENDER_EXTERNAL_HOSTNAME"
    
    # Si existe un workflow, intentar importarlo después del inicio
    if [ -f "/app/n8n/workflows/informe_obra_n8n_workflow.json" ]; then
        echo "📥 Workflow encontrado para importación automática"
        # Copiar workflow al directorio de N8N
        mkdir -p $N8N_USER_FOLDER/workflows
        cp /app/n8n/workflows/informe_obra_n8n_workflow.json $N8N_USER_FOLDER/workflows/
    fi
    
    # Iniciar N8N
    exec n8n start
}

# Función para manejar señales de cierre
cleanup() {
    echo "🛑 Cerrando servicios..."
    if [ ! -z "$NGINX_PID" ]; then
        kill $NGINX_PID 2>/dev/null
    fi
    exit 0
}

trap cleanup SIGTERM SIGINT

# En Render, configurar para un solo servicio en el puerto dinámico
if [ -n "$PORT" ]; then
    echo "☁️  Configuración para Render (Puerto: $PORT)"
    
    # En Render, N8N manejará directamente el puerto y servirá archivos estáticos
    export N8N_PORT=$PORT
    
    # Crear un servidor simple que sirva archivos estáticos y redirija webhooks
    echo "🔧 Configurando servidor unificado..."
    
    # Crear script de servidor personalizado
    cat > /tmp/server.js << 'EOF'
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 5678;

// Servir archivos estáticos
app.use(express.static('/app/public'));

// Proxy para webhooks de N8N
app.use('/webhook', createProxyMiddleware({
    target: `http://localhost:5678`,
    changeOrigin: true,
    pathRewrite: {
        '^/webhook': '/webhook'
    }
}));

// Proxy para interfaz de N8N
app.use('/n8n', createProxyMiddleware({
    target: `http://localhost:5678`,
    changeOrigin: true,
    pathRewrite: {
        '^/n8n': ''
    }
}));

// Fallback para SPA
app.get('*', (req, res) => {
    res.sendFile(path.join('/app/public', 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`🌐 Servidor unificado corriendo en puerto ${PORT}`);
});
EOF
    
    # Instalar express si no está
    cd /app && npm install express http-proxy-middleware 2>/dev/null || echo "Dependencias ya instaladas"
    
    # Iniciar N8N en segundo plano
    echo "⚡ Iniciando N8N en puerto 5678..."
    N8N_PORT=5678 n8n start &
    N8N_PID=$!
    
    # Esperar a que N8N esté listo
    echo "⏳ Esperando a que N8N esté listo..."
    sleep 10
    
    # Iniciar servidor proxy/estático
    echo "🚀 Iniciando servidor principal en puerto $PORT..."
    node /tmp/server.js
else
    # Desarrollo local: iniciar servicios por separado
    echo "🏠 Configuración para desarrollo local"
    start_nginx
    start_n8n
fi
    echo "🔧 Modo Render detectado - Puerto: $PORT"
    export N8N_PORT=$PORT
    
    # En Render, N8N maneja tanto la API como los archivos estáticos
    start_n8n
else
    echo "🔧 Modo desarrollo detectado"
    # Iniciar nginx para archivos estáticos en segundo plano
    start_nginx
    
    # Esperar un momento para que se inicie nginx
    sleep 3
    
    # Iniciar N8N (proceso principal)
    start_n8n
fi
