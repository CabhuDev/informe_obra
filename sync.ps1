#!/usr/bin/env powershell
# Script de sincronización con VPS - Sistema Obratec
# Versión limpia y funcional
param([switch]$DryRun = $false)

$VPS_HOST = "31.97.36.248"
$VPS_USER = "root"  
$VPS_PATH = "/opt/informe_obra"

Write-Host "🔄 SINCRONIZACIÓN VPS - Sistema Obratec" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Blue
Write-Host "VPS: ${VPS_USER}@${VPS_HOST}:${VPS_PATH}" -ForegroundColor White
Write-Host ""

if ($DryRun) {
    Write-Host "🔍 MODO DRY-RUN - Solo mostrando archivos" -ForegroundColor Yellow
    Write-Host ""
}

# Archivos principales a sincronizar
$files = @(
    "server.js",
    "package.json", 
    "public\index.html",
    "public\css\style.css",
    "public\js\script.js",
    "public\js\audioRecord.js",
    "public\js\photoManager.js",
    "public\templates\reportTemplate.html",
    "n8n\workflows\informe_obra_n8n_workflow.json"
)

Write-Host "📁 Archivos a sincronizar:" -ForegroundColor Yellow
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $file (no encontrado)" -ForegroundColor Red
    }
}

if (-not $DryRun) {
    Write-Host ""
    Write-Host "🚀 Sincronizando archivos..." -ForegroundColor Blue
    
    foreach ($file in $files) {
        if (Test-Path $file) {
            $remotePath = $file -replace '\\', '/'
            Write-Host "  📤 $file" -ForegroundColor Cyan
            scp $file "${VPS_USER}@${VPS_HOST}:${VPS_PATH}/$remotePath"
        }
    }
    
    Write-Host ""
    Write-Host "🔄 Reiniciando contenedores..." -ForegroundColor Blue
    ssh "${VPS_USER}@${VPS_HOST}" "cd $VPS_PATH && docker-compose restart"
    
    Write-Host ""
    Write-Host "📊 Estado de contenedores:" -ForegroundColor Blue
    ssh "${VPS_USER}@${VPS_HOST}" "cd $VPS_PATH && docker-compose ps"
    
    Write-Host ""
    Write-Host "🌐 Verificando URLs..." -ForegroundColor Blue
    Start-Sleep 5
    
    try {
        $response1 = Invoke-WebRequest -Uri "https://obratec.app" -Method HEAD -TimeoutSec 10
        Write-Host "  ✅ https://obratec.app - $($response1.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "  ❌ https://obratec.app - Error" -ForegroundColor Red
    }
    
    try {
        $response2 = Invoke-WebRequest -Uri "https://n8n.obratec.app" -Method HEAD -TimeoutSec 10  
        Write-Host "  ✅ https://n8n.obratec.app - $($response2.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "  ❌ https://n8n.obratec.app - Error" -ForegroundColor Red
    }

    try {
        $response3 = Invoke-WebRequest -Uri "https://obratec.app/report-beta" -Method HEAD -TimeoutSec 10
        Write-Host "  ✅ https://obratec.app/report-beta - $($response3.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "  ❌ https://obratec.app/report-beta - Error" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "✅ SINCRONIZACIÓN COMPLETADA" -ForegroundColor Green
Write-Host "🌐 Formulario disponible en:" -ForegroundColor Blue
Write-Host "   • https://obratec.app (ruta principal)" -ForegroundColor White
Write-Host "   • https://obratec.app/report-beta (ruta beta)" -ForegroundColor White
Write-Host "   • https://n8n.obratec.app (administración N8N)" -ForegroundColor White
