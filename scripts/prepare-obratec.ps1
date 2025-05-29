# Script de preparación para despliegue en VPS obratec.app
# Ejecutar en PowerShell: .\prepare-obratec.ps1

Write-Host "🚀 Preparando archivos para despliegue en obratec.app..." -ForegroundColor Green
Write-Host ""

# Verificar si estamos en el directorio correcto
if (-not (Test-Path "docker-compose.vps.yml")) {
    Write-Host "❌ Error: No se encontró docker-compose.vps.yml" -ForegroundColor Red
    Write-Host "   Asegúrate de estar en el directorio del proyecto" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Archivos encontrados correctamente" -ForegroundColor Green

# Verificar Git
try {
    $gitStatus = git status 2>$null
    Write-Host "✅ Repositorio Git configurado" -ForegroundColor Green
} catch {
    Write-Host "❌ Git no configurado. Configurando..." -ForegroundColor Yellow
    git init
    git add .
    git commit -m "Configuración inicial para VPS obratec.app"
}

# Crear archivo .env si no existe
if (-not (Test-Path ".env")) {
    Write-Host "📝 Creando archivo .env desde template..." -ForegroundColor Yellow
    Copy-Item ".env.vps.example" ".env"
    Write-Host "✅ Archivo .env creado" -ForegroundColor Green
} else {
    Write-Host "✅ Archivo .env ya existe" -ForegroundColor Green
}

# Mostrar información importante
Write-Host ""
Write-Host "📋 CONFIGURACIÓN NECESARIA PARA OBRATEC.APP:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. 🔑 EDITA EL ARCHIVO .env CON TUS DATOS REALES:" -ForegroundColor Yellow
Write-Host "   - OPENAI_API_KEY=tu-clave-real-openai" -ForegroundColor White
Write-Host "   - GMAIL_USER=tu-email@gmail.com" -ForegroundColor White  
Write-Host "   - GMAIL_PASSWORD=tu-contraseña-aplicacion-gmail" -ForegroundColor White
Write-Host "   - GMAIL_CLIENT_ID=tu-client-id-google" -ForegroundColor White
Write-Host "   - GMAIL_CLIENT_SECRET=tu-client-secret" -ForegroundColor White
Write-Host ""

Write-Host "2. 🌐 TU DOMINIO YA ESTÁ CONFIGURADO:" -ForegroundColor Yellow
Write-Host "   - obratec.app -> 31.97.36.248" -ForegroundColor Green
Write-Host "   - n8n.obratec.app -> 31.97.36.248" -ForegroundColor Green
Write-Host ""

Write-Host "3. 📤 SUBE EL CÓDIGO A GITHUB:" -ForegroundColor Yellow
Write-Host "   git add ." -ForegroundColor Gray
Write-Host "   git commit -m 'Configuración para VPS obratec.app'" -ForegroundColor Gray
Write-Host "   git push origin main" -ForegroundColor Gray
Write-Host ""

Write-Host "4. 🖥️ EN TU VPS HOSTINGER (31.97.36.248):" -ForegroundColor Yellow
Write-Host "   cd /opt" -ForegroundColor Gray
Write-Host "   git clone https://github.com/TU-USUARIO/informe_obra.git" -ForegroundColor Gray
Write-Host "   cd informe_obra" -ForegroundColor Gray
Write-Host "   chmod +x deploy-vps.sh" -ForegroundColor Gray
Write-Host "   ./deploy-vps.sh" -ForegroundColor Gray
Write-Host ""

# Verificar archivos necesarios
$archivos_necesarios = @(
    "docker-compose.vps.yml",
    ".env.vps.example",
    "deploy-vps.sh",
    "nginx.conf.example",
    "Dockerfile",
    "server.js",
    "package.json",
    "public/index.html"
)

Write-Host "📁 VERIFICACIÓN DE ARCHIVOS:" -ForegroundColor Cyan
foreach ($archivo in $archivos_necesarios) {
    if (Test-Path $archivo) {
        Write-Host "  ✅ $archivo" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $archivo (FALTA)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🎯 URLS FINALES DE TU SISTEMA:" -ForegroundColor Cyan
Write-Host "  🌐 Frontend: https://obratec.app" -ForegroundColor Green
Write-Host "  ⚙️ N8N Admin: https://n8n.obratec.app" -ForegroundColor Green
Write-Host "  🔗 Webhook: https://obratec.app/webhook/form-obra" -ForegroundColor Green
Write-Host "  💊 Health Check: https://obratec.app/health" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 VENTAJAS DE TU VPS:" -ForegroundColor Cyan
Write-Host "  ✅ Dominio personalizado (obratec.app)" -ForegroundColor Green
Write-Host "  ✅ Sin limitaciones de tiempo" -ForegroundColor Green
Write-Host "  ✅ Mejor rendimiento" -ForegroundColor Green
Write-Host "  ✅ Control total del servidor" -ForegroundColor Green
Write-Host "  ✅ HTTPS gratuito con Let's Encrypt" -ForegroundColor Green
Write-Host "  ✅ Siempre activo 24/7" -ForegroundColor Green

Write-Host ""
Write-Host "📖 Consulta DEPLOY_HOSTINGER_VPS.md para instrucciones detalladas" -ForegroundColor Cyan
Write-Host ""

# Preguntar si quiere abrir el archivo .env para editar
$response = Read-Host "¿Quieres abrir el archivo .env para editarlo ahora? (y/N)"
if ($response -eq "y" -or $response -eq "Y") {
    if (Get-Command "code" -ErrorAction SilentlyContinue) {
        code .env
    } else {
        notepad .env
    }
}

Write-Host ""
Write-Host "🚀 ¡Preparación completada! Tu sistema estará en obratec.app" -ForegroundColor Green
