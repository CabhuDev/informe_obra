#!/bin/bash
# Script de inicio para Render con Express + N8N

echo "🚀 Iniciando Sistema de Informes de Obra..."

# Cambiar al directorio de trabajo
cd /app

# Configurar puertos
export APP_PORT=${PORT:-10000}
export N8N_PORT=5678
echo "📡 Puerto aplicación: $APP_PORT"
echo "📡 Puerto N8N: $N8N_PORT"

# Configurar N8N
export N8N_HOST="127.0.0.1"
export N8N_PROTOCOL="http"
export NODE_ENV="production"
export N8N_USER_MANAGEMENT_DISABLED="true"
export N8N_USER_FOLDER="/home/node/.n8n"

# Configurar URLs según el entorno
if [ -n "$RENDER_EXTERNAL_HOSTNAME" ]; then
    export WEBHOOK_URL="https://$RENDER_EXTERNAL_HOSTNAME/webhook/form-obra"
    echo "🌐 Entorno Render: $RENDER_EXTERNAL_HOSTNAME"
    echo "📬 Webhook: $WEBHOOK_URL"
else
    export WEBHOOK_URL="http://localhost:$APP_PORT/webhook/form-obra"
    echo "🔧 Entorno local: $WEBHOOK_URL"
fi

# Verificar configuración
echo "🔍 Verificando variables..."
echo "✅ OpenAI: $([ -n "$OPENAI_API_KEY" ] && echo "Configurada" || echo "NO configurada")"
echo "✅ Gmail: $([ -n "$GMAIL_USER" ] && echo "Configurada" || echo "NO configurada")"
echo "✅ Google: $([ -n "$GOOGLE_CLIENT_ID" ] && echo "Configurada" || echo "NO configurada")"

# Verificar que el directorio .n8n existe
mkdir -p "$N8N_USER_FOLDER"
chown -R node:node "$N8N_USER_FOLDER" 2>/dev/null || true

# Importar workflows si existen
if [ -d "/tmp/n8n-workflows/workflows" ]; then
    echo "📥 Importando workflows..."
    mkdir -p "$N8N_USER_FOLDER/workflows"
    cp -r /tmp/n8n-workflows/workflows/* "$N8N_USER_FOLDER/workflows/" 2>/dev/null || true
    chown -R node:node "$N8N_USER_FOLDER" 2>/dev/null || true
fi

echo "🔧 Iniciando N8N en segundo plano..."
# Iniciar N8N en segundo plano con redirección de logs
n8n start \
  --tunnel=false \
  --host="127.0.0.1" \
  --port="$N8N_PORT" > /tmp/n8n.log 2>&1 &

N8N_PID=$!
echo "📝 N8N PID: $N8N_PID"

# Función para verificar si N8N está listo
wait_for_n8n() {
    echo "⏳ Esperando N8N..."
    for i in {1..30}; do
        if curl -f -s "http://127.0.0.1:$N8N_PORT/healthz" > /dev/null 2>&1; then
            echo "✅ N8N está listo!"
            return 0
        fi
        echo "⏳ Intento $i/30..."
        sleep 2
    done
    echo "❌ N8N no respondió a tiempo"
    return 1
}

# Esperar a que N8N esté listo
if ! wait_for_n8n; then
    echo "🔍 Verificando logs de N8N..."
    tail -20 /tmp/n8n.log || echo "No se pudieron leer los logs"
fi

echo "🌐 Iniciando servidor Express..."
# Iniciar servidor Express en primer plano
exec node server.js
