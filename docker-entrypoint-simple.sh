#!/bin/bash
# Script de inicio simplificado para Render

echo "🚀 Iniciando Sistema de Informes de Obra..."

# Configurar puerto
export N8N_PORT=${PORT:-5678}
echo "📡 Puerto configurado: $N8N_PORT"

# Configurar N8N
export N8N_HOST="0.0.0.0"
export N8N_PROTOCOL="http"
export NODE_ENV="production"
export N8N_USER_MANAGEMENT_DISABLED="true"

# Configurar URLs según el entorno
if [ -n "$RENDER_EXTERNAL_HOSTNAME" ]; then
    export WEBHOOK_URL="https://$RENDER_EXTERNAL_HOSTNAME/webhook/form-obra"
    echo "🌐 Entorno Render: $RENDER_EXTERNAL_HOSTNAME"
    echo "📬 Webhook: $WEBHOOK_URL"
else
    export WEBHOOK_URL="http://localhost:$N8N_PORT/webhook/form-obra"
    echo "🔧 Entorno local: $WEBHOOK_URL"
fi

# Verificar configuración
echo "🔍 Verificando variables..."
echo "✅ OpenAI: $([ -n "$OPENAI_API_KEY" ] && echo "Configurada" || echo "NO configurada")"
echo "✅ Gmail: $([ -n "$GMAIL_USER" ] && echo "Configurada" || echo "NO configurada")"
echo "✅ Google: $([ -n "$GOOGLE_CLIENT_ID" ] && echo "Configurada" || echo "NO configurada")"

# Configurar directorio de datos
export N8N_USER_FOLDER="/home/node/.n8n"
mkdir -p "$N8N_USER_FOLDER"

# Importar workflows si existen
if [ -d "/tmp/n8n-workflows/workflows" ]; then
    echo "📥 Importando workflows..."
    cp -r /tmp/n8n-workflows/workflows/* "$N8N_USER_FOLDER/workflows/" 2>/dev/null || true
fi

# Manejar archivos estáticos en Render
if [ -n "$PORT" ]; then
    echo "☁️ Configuración Render - Puerto: $PORT"
    
    # En Render, usamos N8N directamente para todo
    # N8N puede servir archivos estáticos usando express
    
    # Crear directorio para archivos estáticos dentro de N8N
    mkdir -p "$N8N_USER_FOLDER/static"
    cp -r /app/public/* "$N8N_USER_FOLDER/static/" 2>/dev/null || true
    
    # Configurar N8N para servir archivos estáticos
    export N8N_SERVE_FILES="true"
    export N8N_STATIC_FILES="$N8N_USER_FOLDER/static"
fi

echo "⚡ Iniciando N8N..."

# Iniciar N8N con configuración completa
exec n8n start \
  --tunnel=false \
  --host="0.0.0.0" \
  --port="$N8N_PORT"
