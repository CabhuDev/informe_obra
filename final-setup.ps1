# Script final de preparación para GitHub - obratec.app
# Ejecutar: .\final-setup.ps1

Write-Host "🎯 PREPARANDO SISTEMA DE INFORMES PARA obratec.app" -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Green
Write-Host ""

# Verificar archivos críticos
$archivos_criticos = @(
    "docker-compose.vps.yml",
    ".env.vps.example", 
    "deploy-vps.sh",
    "nginx.conf.example",
    "Dockerfile",
    "server.js",
    "package.json",
    "public/index.html",
    "DEPLOY_OBRATEC_GUIA.md"
)

Write-Host "📋 VERIFICACIÓN DE ARCHIVOS CRÍTICOS:" -ForegroundColor Cyan
$archivos_faltantes = @()
foreach ($archivo in $archivos_criticos) {
    if (Test-Path $archivo) {
        Write-Host "  ✅ $archivo" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $archivo (FALTA)" -ForegroundColor Red
        $archivos_faltantes += $archivo
    }
}

if ($archivos_faltantes.Count -gt 0) {
    Write-Host ""
    Write-Host "❌ FALTAN ARCHIVOS CRÍTICOS. No se puede continuar." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ TODOS LOS ARCHIVOS ESTÁN LISTOS" -ForegroundColor Green
Write-Host ""

# Mostrar resumen de configuración
Write-Host "🌐 CONFIGURACIÓN DEL SISTEMA:" -ForegroundColor Cyan
Write-Host "  Dominio principal: obratec.app" -ForegroundColor White
Write-Host "  Subdominio N8N: n8n.obratec.app" -ForegroundColor White  
Write-Host "  IP del VPS: 31.97.36.248" -ForegroundColor White
Write-Host "  Plataforma: Hostinger VPS" -ForegroundColor White
Write-Host ""

Write-Host "🎯 URLS FINALES:" -ForegroundColor Cyan
Write-Host "  🌐 Frontend: https://obratec.app" -ForegroundColor Green
Write-Host "  ⚙️ N8N Admin: https://n8n.obratec.app" -ForegroundColor Green  
Write-Host "  🔗 Webhook: https://obratec.app/webhook/form-obra" -ForegroundColor Green
Write-Host "  💊 Health: https://obratec.app/health" -ForegroundColor Green
Write-Host ""

# Verificar Git
Write-Host "📦 VERIFICANDO GIT:" -ForegroundColor Cyan
try {
    $gitBranch = git branch --show-current 2>$null
    Write-Host "  ✅ Rama actual: $gitBranch" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Git no configurado" -ForegroundColor Red
    Write-Host "  Configurando Git..." -ForegroundColor Yellow
    git init
    git add .
    git commit -m "Configuración inicial VPS obratec.app"
}

Write-Host ""
Write-Host "🚀 PRÓXIMOS PASOS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. 🔑 CONFIGURA TUS CLAVES:" -ForegroundColor Yellow
Write-Host "   Edita el archivo .env con tus datos reales:" -ForegroundColor White
Write-Host "   - OPENAI_API_KEY=tu-clave-openai" -ForegroundColor Gray
Write-Host "   - GMAIL_USER=tu-email@gmail.com" -ForegroundColor Gray
Write-Host "   - GMAIL_PASSWORD=tu-app-password" -ForegroundColor Gray
Write-Host ""

Write-Host "2. 📤 SUBE A GITHUB:" -ForegroundColor Yellow
Write-Host "   git add ." -ForegroundColor Gray
Write-Host "   git commit -m 'Sistema listo para obratec.app'" -ForegroundColor Gray  
Write-Host "   git push origin main" -ForegroundColor Gray
Write-Host ""

Write-Host "3. 🖥️ EN TU VPS (31.97.36.248):" -ForegroundColor Yellow
Write-Host "   ssh root@31.97.36.248" -ForegroundColor Gray
Write-Host "   cd /opt" -ForegroundColor Gray
Write-Host "   git clone https://github.com/TU-USUARIO/informe_obra.git" -ForegroundColor Gray
Write-Host "   cd informe_obra" -ForegroundColor Gray
Write-Host "   chmod +x deploy-vps.sh" -ForegroundColor Gray
Write-Host "   ./deploy-vps.sh" -ForegroundColor Gray
Write-Host ""

Write-Host "4. 🌐 CONFIGURAR NGINX + HTTPS:" -ForegroundColor Yellow
Write-Host "   cp nginx.conf.example /etc/nginx/sites-available/obratec.app" -ForegroundColor Gray
Write-Host "   ln -s /etc/nginx/sites-available/obratec.app /etc/nginx/sites-enabled/" -ForegroundColor Gray
Write-Host "   certbot --nginx -d obratec.app -d www.obratec.app -d n8n.obratec.app" -ForegroundColor Gray
Write-Host ""

Write-Host "📖 DOCUMENTACIÓN COMPLETA:" -ForegroundColor Cyan
Write-Host "   Consulta DEPLOY_OBRATEC_GUIA.md para instrucciones detalladas" -ForegroundColor White
Write-Host ""

# Preguntar si quiere abrir el .env
$response = Read-Host "¿Quieres abrir el archivo .env para configurar tus claves ahora? (y/N)"
if ($response -eq "y" -or $response -eq "Y") {
    if (Get-Command "code" -ErrorAction SilentlyContinue) {
        Write-Host "🔧 Abriendo .env en VS Code..." -ForegroundColor Blue
        code .env
    } else {
        Write-Host "🔧 Abriendo .env en Notepad..." -ForegroundColor Blue
        notepad .env
    }
}

Write-Host ""
Write-Host "🎉 SISTEMA LISTO PARA DESPLIEGUE EN obratec.app" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Tu sistema de informes de obra estará disponible en:" -ForegroundColor White
Write-Host "https://obratec.app" -ForegroundColor Green -BackgroundColor Black
Write-Host ""
