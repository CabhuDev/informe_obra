param([switch]$DryRun = $false)

$VPS_HOST = "31.97.36.248"
$VPS_USER = "root"  
$VPS_PATH = "/opt/informe_obra"

Write-Host "SINCRONIZACION VPS - Sistema Obratec" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Blue
Write-Host "VPS: ${VPS_USER}@${VPS_HOST}:${VPS_PATH}" -ForegroundColor White
Write-Host ""

if ($DryRun) {
    Write-Host "MODO DRY-RUN - Solo mostrando archivos" -ForegroundColor Yellow
    Write-Host ""
}

# Archivos principales a sincronizar
$files = @(
    #".env",
    #"server.js",
    #"package.json",
    #"docker-compose.yml",
    "public\pages\landing.html",
    "public\pages\form-report.html",
    "public\pages\waitlist-form.html",
    "public\css\style.css",
    "public\css\landing.css",
    "public\css\waitlist.css"
    #"public\js\script.js",
    #"public\js\audioRecord.js",
    #"public\js\photoManager.js",
    #"public\js\waitlist.js",
    #"public\js\heicConverter.js",
    #"public\templates\reportTemplateAI.html",
    #"public\templates\example-report.pdf",
    #"public\templates\reportphotos.js",
    #"n8n\workflows\informe_obra_n8n_workflow.json"
)

Write-Host "Archivos a sincronizar:" -ForegroundColor Yellow
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "  OK $file" -ForegroundColor Green
    } else {
        Write-Host "  MISSING $file" -ForegroundColor Red
    }
}

if (-not $DryRun) {
    Write-Host ""
    Write-Host "Sincronizando archivos..." -ForegroundColor Blue
    
    foreach ($file in $files) {
        if (Test-Path $file) {
            $remotePath = $file -replace '\\', '/'
            Write-Host "  Uploading $file" -ForegroundColor Cyan
            scp $file "${VPS_USER}@${VPS_HOST}:${VPS_PATH}/$remotePath"
        }
    }
      Write-Host ""
    Write-Host "Reconstruyendo imagen con archivos actualizados..." -ForegroundColor Blue
    ssh "${VPS_USER}@${VPS_HOST}" "cd $VPS_PATH; docker-compose down"
    ssh "${VPS_USER}@${VPS_HOST}" "cd $VPS_PATH; docker-compose build --no-cache app"
    ssh "${VPS_USER}@${VPS_HOST}" "cd $VPS_PATH; docker-compose up -d"
    
    Write-Host ""
    Write-Host "Estado de contenedores:" -ForegroundColor Blue
    ssh "${VPS_USER}@${VPS_HOST}" "cd $VPS_PATH; docker-compose ps"
    
    Write-Host ""
    Write-Host "Verificando URLs..." -ForegroundColor Blue
    Start-Sleep 5
    
    try {
        $response1 = Invoke-WebRequest -Uri "https://obratec.app" -Method HEAD -TimeoutSec 10
        Write-Host "  OK https://obratec.app - $($response1.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "  ERROR https://obratec.app" -ForegroundColor Red
    }
    
    try {
        $response2 = Invoke-WebRequest -Uri "https://n8n.obratec.app" -Method HEAD -TimeoutSec 10  
        Write-Host "  OK https://n8n.obratec.app - $($response2.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "  ERROR https://n8n.obratec.app" -ForegroundColor Red
    }

    try {
        $response3 = Invoke-WebRequest -Uri "https://obratec.app/form-report" -Method HEAD -TimeoutSec 10
        Write-Host "  OK https://obratec.app/form-report - $($response3.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "  ERROR https://obratec.app/form-report" -ForegroundColor Red
    }
    
    try {
        $response4 = Invoke-WebRequest -Uri "https://obratec.app/waitlist" -Method HEAD -TimeoutSec 10
        Write-Host "  OK https://obratec.app/waitlist - $($response4.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "  ERROR https://obratec.app/waitlist" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "SINCRONIZACION COMPLETADA" -ForegroundColor Green
Write-Host "Formulario disponible en:" -ForegroundColor Blue
Write-Host "   • https://obratec.app" -ForegroundColor White
Write-Host "   • https://obratec.app/form-report" -ForegroundColor White
Write-Host "   • https://obratec.app/waitlist" -ForegroundColor White
Write-Host "   • https://n8n.obratec.app" -ForegroundColor White
