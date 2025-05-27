#!/bin/bash

# Script para desplegar en Render
echo "🚀 Preparando despliegue para Render..."

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ]; then
    echo "❌ Error: No se encuentra package.json. Ejecuta este script desde el directorio del proyecto."
    exit 1
fi

# Verificar archivos necesarios
echo "📋 Verificando archivos necesarios..."
required_files=("server.js" "docker-entrypoint.sh" "Dockerfile" "public/index.html")

for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Error: Falta el archivo $file"
        exit 1
    fi
    echo "✅ $file encontrado"
done

# Hacer ejecutable el script de Docker
chmod +x docker-entrypoint.sh

echo "📦 Archivos verificados y listos para despliegue"
echo ""
echo "🔗 Próximos pasos para Render:"
echo "1. Sube el código a GitHub:"
echo "   git add ."
echo "   git commit -m 'Sistema listo para Render'"
echo "   git push origin main"
echo ""
echo "2. Ve a https://dashboard.render.com"
echo "3. Crear nuevo Web Service"
echo "4. Conectar tu repositorio de GitHub"
echo "5. Configurar:"
echo "   - Environment: Docker"
echo "   - Plan: Free"
echo "   - Auto-Deploy: Yes"
echo ""
echo "6. Variables de entorno requeridas:"
echo "   WEBHOOK_URL=https://tu-app.onrender.com/webhook/form-obra"
echo "   OPENAI_API_KEY=tu-api-key"
echo "   GMAIL_USER=tu-email@gmail.com"
echo "   GMAIL_PASSWORD=tu-app-password"
echo ""
echo "🎉 ¡Tu sistema estará disponible en https://tu-app.onrender.com!"
