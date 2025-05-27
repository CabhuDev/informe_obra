# Script de preparacion para despliegue en Render
# Sistema de Informes de Obra

Write-Host "Preparando Sistema de Informes de Obra para Render..." -ForegroundColor Green
Write-Host ""

# Verificar que estamos en el directorio correcto
if (-not (Test-Path "package.json")) {
    Write-Host "Error: No se encuentra package.json" -ForegroundColor Red
    Write-Host "Ejecuta este script desde el directorio del proyecto" -ForegroundColor Yellow
    exit 1
}

Write-Host "Verificando archivos necesarios..." -ForegroundColor Cyan

# Lista de archivos requeridos
$requiredFiles = @(
    "server.js",
    "docker-entrypoint.sh", 
    "Dockerfile",
    "package.json",
    "render.yaml",
    "public/index.html",
    "n8n/workflows/informe_obra_n8n_workflow.json"
)

$allFilesPresent = $true

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "OK: $file" -ForegroundColor Green
    } else {
        Write-Host "FALTA: $file" -ForegroundColor Red
        $allFilesPresent = $false
    }
}

if (-not $allFilesPresent) {
    Write-Host ""
    Write-Host "Faltan archivos necesarios. Revisa la estructura del proyecto." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Verificando dependencias..." -ForegroundColor Cyan

# Verificar si node_modules existe
if (-not (Test-Path "node_modules")) {
    Write-Host "Instalando dependencias..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error instalando dependencias" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Dependencias ya instaladas" -ForegroundColor Green
}

Write-Host ""
Write-Host "Sistema listo para despliegue en Render!" -ForegroundColor Green
Write-Host ""
Write-Host "Proximos pasos:" -ForegroundColor Yellow
Write-Host "1. Sube el codigo a GitHub:" -ForegroundColor White
Write-Host "   git add ." -ForegroundColor Gray
Write-Host "   git commit -m 'Sistema listo para Render'" -ForegroundColor Gray  
Write-Host "   git push origin main" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Ve a https://dashboard.render.com" -ForegroundColor White
Write-Host "3. New -> Web Service -> Conecta tu repo" -ForegroundColor White
Write-Host "4. Environment: Docker, Plan: Free" -ForegroundColor White
Write-Host ""
Write-Host "5. Variables de entorno OBLIGATORIAS:" -ForegroundColor Yellow
Write-Host "   OPENAI_API_KEY=tu-api-key" -ForegroundColor Gray
Write-Host "   GMAIL_USER=tu-email@gmail.com" -ForegroundColor Gray
Write-Host "   GMAIL_PASSWORD=tu-app-password" -ForegroundColor Gray
Write-Host "   WEBHOOK_URL=https://tu-app.onrender.com/webhook/form-obra" -ForegroundColor Gray
Write-Host ""
Write-Host "Consulta DEPLOY_GUIDE.md para detalles completos" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tu sistema estara en: https://tu-app.onrender.com" -ForegroundColor Green
