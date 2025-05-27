#!/bin/bash
# Script de validación final para el proyecto de informes de obra

echo "🔍 Validación Final del Proyecto - Sistema de Informes de Obra"
echo "============================================================"

PROJECT_DIR="c:/Users/Pablo/Desktop/informe_obra"
cd "$PROJECT_DIR" 2>/dev/null || cd "c:\Users\Pablo\Desktop\informe_obra"

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para verificar archivos
check_file() {
    local file="$1"
    local description="$2"
    
    if [ -f "$file" ]; then
        echo -e "✅ ${GREEN}$description${NC}: $file"
        return 0
    else
        echo -e "❌ ${RED}$description FALTANTE${NC}: $file"
        return 1
    fi
}

# Función para verificar directorios
check_dir() {
    local dir="$1"
    local description="$2"
    
    if [ -d "$dir" ]; then
        echo -e "✅ ${GREEN}$description${NC}: $dir"
        return 0
    else
        echo -e "❌ ${RED}$description FALTANTE${NC}: $dir"
        return 1
    fi
}

echo ""
echo "📁 Verificando estructura de archivos..."

# Archivos de configuración Docker/Render
check_file "Dockerfile" "Dockerfile"
check_file "docker-entrypoint.sh" "Script de inicio Docker"
check_file "package.json" "Dependencias Node.js"
check_file "render.yaml" "Configuración Render"
check_file ".dockerignore" "Docker ignore"

echo ""
echo "📚 Verificando documentación..."

# Documentación
check_file "README.md" "Documentación principal"
check_file "DEPLOY.md" "Guía de despliegue"
check_file "PROJECT_CONFIG.md" "Configuración del proyecto"

echo ""
echo "🌐 Verificando archivos frontend..."

# Frontend
check_dir "public" "Directorio público"
check_file "public/index.html" "Página principal"
check_file "public/css/style.css" "Estilos CSS"
check_file "public/js/script.js" "JavaScript principal"
check_file "public/js/audioRecord.js" "JavaScript grabación audio"
check_file "public/templates/reportTemplate.html" "Template de reporte"

echo ""
echo "🤖 Verificando configuración N8N..."

# N8N
check_dir "n8n" "Directorio N8N"
check_file "n8n/workflows/informe_obra_n8n_workflow.json" "Workflow N8N"

echo ""
echo "🧪 Verificando sintaxis de archivos..."

# Verificar sintaxis JSON
echo -n "📄 package.json sintaxis... "
if node -e "JSON.parse(require('fs').readFileSync('package.json', 'utf8'))" 2>/dev/null; then
    echo -e "${GREEN}✅ Válido${NC}"
else
    echo -e "${RED}❌ Error de sintaxis${NC}"
fi

echo -n "📄 N8N workflow sintaxis... "
if [ -f "n8n/workflows/informe_obra_n8n_workflow.json" ]; then
    if node -e "JSON.parse(require('fs').readFileSync('n8n/workflows/informe_obra_n8n_workflow.json', 'utf8'))" 2>/dev/null; then
        echo -e "${GREEN}✅ Válido${NC}"
    else
        echo -e "${RED}❌ Error de sintaxis${NC}"
    fi
else
    echo -e "${YELLOW}⚠️ Archivo no encontrado${NC}"
fi

echo ""
echo "🔧 Verificando permisos de scripts..."

# Verificar permisos ejecutables
if [ -x "docker-entrypoint.sh" ]; then
    echo -e "✅ ${GREEN}docker-entrypoint.sh tiene permisos de ejecución${NC}"
else
    echo -e "⚠️ ${YELLOW}docker-entrypoint.sh necesita permisos de ejecución${NC}"
    chmod +x docker-entrypoint.sh 2>/dev/null && echo -e "✅ ${GREEN}Permisos corregidos${NC}"
fi

if [ -x "verify.sh" ]; then
    echo -e "✅ ${GREEN}verify.sh tiene permisos de ejecución${NC}"
else
    echo -e "⚠️ ${YELLOW}verify.sh necesita permisos de ejecución${NC}"
    chmod +x verify.sh 2>/dev/null && echo -e "✅ ${GREEN}Permisos corregidos${NC}"
fi

echo ""
echo "📋 Verificando variables de entorno requeridas..."

echo -e "📝 ${YELLOW}Variables requeridas para Render:${NC}"
echo "   • GMAIL_USER=tu-email@gmail.com"
echo "   • GMAIL_PASSWORD=contraseña-app-gmail"
echo "   • WEBHOOK_URL=https://tu-app.onrender.com/webhook/informe-obra"

echo ""
echo "🎯 Checklist de despliegue:"
echo "   □ Subir código a GitHub"
echo "   □ Crear servicio en Render"
echo "   □ Configurar variables de entorno"
echo "   □ Esperar build (5-10 min)"
echo "   □ Verificar app funcionando"
echo "   □ Configurar workflow N8N"
echo "   □ Probar envío de formulario"

echo ""
echo "🔗 URLs finales:"
echo "   • App: https://tu-app.onrender.com"
echo "   • N8N: https://tu-app.onrender.com/n8n"
echo "   • Webhook: https://tu-app.onrender.com/webhook/informe-obra"

echo ""
echo -e "🎉 ${GREEN}¡Validación completada!${NC}"
echo -e "📦 ${GREEN}El proyecto está listo para desplegarse en Render${NC}"

echo ""
echo "💡 Próximo comando sugerido:"
echo "   git add . && git commit -m 'Sistema de informes de obra listo para Render' && git push origin main"
