#!/bin/bash
# Script de inicio para Render con Express + N8N

echo "🚀 Iniciando Sistema de Informes de Obra..."

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

# Configurar directorio de datos
export N8N_USER_FOLDER="/home/node/.n8n"
mkdir -p "$N8N_USER_FOLDER"

# Importar workflows si existen
if [ -d "/tmp/n8n-workflows/workflows" ]; then
    echo "📥 Importando workflows..."
    cp -r /tmp/n8n-workflows/workflows/* "$N8N_USER_FOLDER/workflows/" 2>/dev/null || true
fi

echo "🔧 Iniciando N8N en segundo plano..."
# Iniciar N8N en segundo plano
n8n start \
  --tunnel=false \
  --host="127.0.0.1" \
  --port="$N8N_PORT" &

# Esperar a que N8N esté listo
echo "⏳ Esperando N8N..."
sleep 10

echo "🌐 Iniciando servidor Express..."
# Iniciar servidor Express en primer plano
exec node server.js
