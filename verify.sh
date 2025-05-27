#!/bin/bash
# Script de verificación para el despliegue en Render

echo "🔍 Verificando despliegue de Sistema de Informes de Obra..."

# Verificar si tenemos la URL
if [ -z "$1" ]; then
    echo "❌ Error: Proporciona la URL de tu app"
    echo "Uso: ./verify.sh https://tu-app.onrender.com"
    exit 1
fi

APP_URL="$1"
echo "🌐 URL a verificar: $APP_URL"

# Función para verificar endpoint
check_endpoint() {
    local url="$1"
    local description="$2"
    local expected_code="${3:-200}"
    
    echo -n "📡 Verificando $description... "
    
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null)
    
    if [ "$response" = "$expected_code" ]; then
        echo "✅ OK ($response)"
        return 0
    else
        echo "❌ Error ($response)"
        return 1
    fi
}

# Verificar endpoints principales
echo ""
echo "🧪 Ejecutando pruebas..."

check_endpoint "$APP_URL" "Página principal"
check_endpoint "$APP_URL/n8n/" "Panel N8N"
check_endpoint "$APP_URL/css/style.css" "Archivos CSS"
check_endpoint "$APP_URL/js/script.js" "Archivos JavaScript"

# Verificar webhook (debería devolver error 400 sin datos)
echo -n "📬 Verificando webhook... "
webhook_response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$APP_URL/webhook/informe-obra" 2>/dev/null)
if [ "$webhook_response" = "400" ] || [ "$webhook_response" = "404" ] || [ "$webhook_response" = "200" ]; then
    echo "✅ OK (responde: $webhook_response)"
else
    echo "❌ Error ($webhook_response)"
fi

# Probar envío de datos de prueba
echo ""
echo "🧪 Probando envío de formulario..."

test_data='{
    "projectName": "Proyecto Test",
    "date": "2025-05-27",
    "advance": "75",
    "observations": "Prueba de verificación automática",
    "problems": "Ninguno",
    "supervisor": "Test User",
    "email": "test@example.com"
}'

echo -n "📤 Enviando datos de prueba... "
test_response=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST \
    -H "Content-Type: application/json" \
    -d "$test_data" \
    "$APP_URL/webhook/informe-obra" 2>/dev/null)

if [ "$test_response" = "200" ] || [ "$test_response" = "201" ]; then
    echo "✅ OK (webhook funcional)"
else
    echo "⚠️  Webhook responde pero puede necesitar configuración ($test_response)"
fi

echo ""
echo "📊 Resumen de la verificación:"
echo "🌐 App URL: $APP_URL"
echo "🔧 Panel N8N: $APP_URL/n8n/"
echo "📬 Webhook: $APP_URL/webhook/informe-obra"

echo ""
echo "🎯 Próximos pasos:"
echo "1. Visita $APP_URL para ver el formulario"
echo "2. Accede a $APP_URL/n8n/ para configurar N8N"
echo "3. Importa el workflow desde n8n/workflows/informe_obra_n8n_workflow.json"
echo "4. Configura las credenciales de Gmail"
echo "5. Activa el workflow"

echo ""
echo "✨ Verificación completada!"
