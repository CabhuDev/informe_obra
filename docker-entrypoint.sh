#!/bin/bash
set -e

echo "🚀 Iniciando Sistema de Informes de Obra..."
echo "⏰ Timestamp: $(date)"

# Variables de entorno para N8N
export N8N_HOST="0.0.0.0"
export N8N_PORT=${PORT:-5678}
export N8N_PROTOCOL="http"
export WEBHOOK_URL="${WEBHOOK_URL:-http://localhost:${PORT}/webhook/}"
export N8N_EDITOR_BASE_URL="/n8n/"

# Configuración de N8N para producción
export NODE_ENV="production"
export N8N_METRICS="true"
export N8N_LOG_LEVEL="info"
export N8N_LOG_OUTPUT="console"

# Configuración de autenticación (para producción usar credenciales reales)
export N8N_BASIC_AUTH_ACTIVE="false"
export N8N_USER_MANAGEMENT_DISABLED="true"

# Configuración de webhooks
export N8N_PAYLOAD_SIZE_MAX="50"
export N8N_SKIP_WEBHOOK_DEREGISTRATION_SHUTDOWN="true"

echo "📡 Configuración de red:"
echo "   - Host: $N8N_HOST"
echo "   - Puerto: $N8N_PORT"
echo "   - Webhook URL: $WEBHOOK_URL"
echo "   - Editor URL: $N8N_EDITOR_BASE_URL"

# Crear directorio de workflows si no existe
mkdir -p /home/node/.n8n/workflows

# Importar workflow si existe
if [ -f "/app/n8n/workflows/informe_obra_n8n_workflow.json" ]; then
    echo "📂 Importando workflow de informes de obra..."
    cp /app/n8n/workflows/informe_obra_n8n_workflow.json /home/node/.n8n/workflows/
    echo "✅ Workflow importado correctamente"
else
    echo "⚠️  No se encontró workflow para importar"
fi

# Función para verificar si N8N está listo
wait_for_n8n() {
    echo "⏳ Esperando que N8N esté listo..."
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s -f http://localhost:${N8N_PORT}/healthz > /dev/null 2>&1; then
            echo "✅ N8N está listo (intento $attempt/$max_attempts)"
            return 0
        fi
        echo "⏳ N8N no está listo aún (intento $attempt/$max_attempts)..."
        sleep 2
        ((attempt++))
    done
    
    echo "❌ N8N no pudo iniciarse después de $max_attempts intentos"
    return 1
}

# Iniciar N8N en background
echo "🔧 Iniciando N8N..."
n8n start > /tmp/n8n.log 2>&1 &
N8N_PID=$!

echo "📊 N8N iniciado con PID: $N8N_PID"

# Verificar que N8N esté funcionando
if wait_for_n8n; then
    echo "✅ N8N iniciado correctamente"
    echo "🌐 N8N disponible en: http://localhost:${N8N_PORT}"
    echo "📊 Health check: http://localhost:${N8N_PORT}/healthz"
else
    echo "❌ Error al iniciar N8N"
    echo "📋 Logs de N8N:"
    cat /tmp/n8n.log
    exit 1
fi

# Instalar dependencias del frontend si es necesario
if [ ! -d "/app/node_modules" ]; then
    echo "📦 Instalando dependencias del frontend..."
    cd /app && npm install --only=production
fi

# Iniciar servidor del frontend
echo "🌐 Iniciando servidor frontend..."
echo "📡 Puerto del frontend: ${PORT:-10000}"
cd /app

# Función para manejar señales de cierre
cleanup() {
    echo "🔄 Recibida señal de cierre..."
    echo "🛑 Deteniendo N8N (PID: $N8N_PID)..."
    kill $N8N_PID 2>/dev/null || true
    echo "🛑 Deteniendo frontend..."
    exit 0
}

# Configurar manejo de señales
trap cleanup SIGTERM SIGINT

# Iniciar el servidor frontend y mantener el script corriendo
echo "🚀 Sistema completamente iniciado"
echo "📱 Frontend: http://localhost:${PORT:-10000}"
echo "⚙️  N8N Editor: http://localhost:${PORT:-10000}/n8n"
echo "🔗 Webhook: http://localhost:${PORT:-10000}/webhook/form-obra"

npm start
