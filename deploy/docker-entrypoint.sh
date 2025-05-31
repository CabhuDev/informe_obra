#!/bin/bash

# Script de inicio para el contenedor de la aplicación
# Maneja tanto el frontend Express como el proxy a N8N

set -e

echo "🚀 Iniciando aplicación obratec.app..."

# Función para logging con timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Verificar variables de entorno críticas
log "Verificando configuración..."

if [ -z "$WEBHOOK_URL" ]; then
    log "⚠️  WEBHOOK_URL no configurada, usando default"
    export WEBHOOK_URL="https://obratec.app/webhook/form-obra"
fi

if [ -z "$NODE_ENV" ]; then
    export NODE_ENV="production"
fi

if [ -z "$PORT" ]; then
    export PORT="3000"
fi

log "✅ Configuración verificada:"
log "   NODE_ENV: $NODE_ENV"
log "   PORT: $PORT"
log "   WEBHOOK_URL: $WEBHOOK_URL"

# Instalar dependencias si no están instaladas
if [ ! -d "/app/node_modules" ]; then
    log "📦 Instalando dependencias de Node.js..."
    cd /app
    npm install --production --silent
    log "✅ Dependencias instaladas"
fi

# Verificar que los archivos necesarios existen
if [ ! -f "/app/server.js" ]; then
    log "❌ Error: server.js no encontrado"
    exit 1
fi

if [ ! -d "/app/public" ]; then
    log "❌ Error: directorio public no encontrado"
    exit 1
fi

log "✅ Archivos de aplicación verificados"

# Crear directorio de logs si no existe (en el directorio de la app)
mkdir -p /app/logs

# Función para manejar señales de terminación
cleanup() {
    log "🛑 Recibida señal de terminación, cerrando aplicación..."
    kill -TERM "$child" 2>/dev/null || true
    wait "$child"
    log "✅ Aplicación cerrada correctamente"
    exit 0
}

# Configurar manejadores de señales
trap cleanup SIGTERM SIGINT

# Esperar un momento para que N8N esté listo (si está en el mismo stack)
log "⏳ Esperando servicios dependientes..."
sleep 5

# Iniciar la aplicación Express
log "🚀 Iniciando servidor Express en puerto $PORT..."
cd /app

# Ejecutar la aplicación en background y capturar PID
node server.js &
child=$!

log "✅ Aplicación iniciada (PID: $child)"
log "🌐 Acceso frontend: http://localhost:$PORT"
log "⚙️ Proxy N8N: http://localhost:$PORT/n8n/"
log "🔗 Webhook: http://localhost:$PORT/webhook/"
log "💊 Health check: http://localhost:$PORT/health"

# Esperar a que termine el proceso hijo
wait "$child"
