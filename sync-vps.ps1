#!/usr/bin/env powershell
# Script de sincronización con VPS - Estructura reorganizada
# Sincroniza solo los archivos necesarios manteniendo el sistema funcionando

param(
    [switch]$DryRun = $false,
    [switch]$Force = $false
)

$VPS_HOST = "31.97.36.248"
$VPS_USER = "root"
$VPS_PATH = "/opt/informe_obra"
$LOCAL_PATH = $PSScriptRoot

Write-Host "🔄 SINCRONIZACIÓN VPS - Sistema Obratec" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Blue
Write-Host "Local:  $LOCAL_PATH" -ForegroundColor White
Write-Host "VPS:    ${VPS_USER}@${VPS_HOST}:${VPS_PATH}" -ForegroundColor White
Write-Host ""

if ($DryRun) {
    Write-Host "🔍 MODO DRY-RUN - Solo mostrando cambios" -ForegroundColor Yellow
}

# Archivos críticos que requieren reinicio de contenedores
$criticalFiles = @(
    "server.js",
    "package.json",
    "public\js\audioRecord.js",
    "public\index.html"
)

# Archivos de configuración
$configFiles = @(
    ".env",
    "deploy\docker-compose.vps.yml"
)

# Workflows de N8N
$n8nFiles = @(
    "n8n\workflows\informe_obra_n8n_workflow.json"
)

function Sync-Files {
    param($fileList, $description, $requiresRestart = $false)
    
    Write-Host "📁 Sincronizando $description..." -ForegroundColor Yellow
    
    foreach ($file in $fileList) {
        if (Test-Path $file) {
            $relativePath = $file -replace '\\', '/'
            Write-Host "  ✅ $relativePath" -ForegroundColor Green
            
            if (-not $DryRun) {
                try {
                    $scpResult = scp "$file" "${VPS_USER}@${VPS_HOST}:${VPS_PATH}/$relativePath" 2>&1
                    if ($LASTEXITCODE -ne 0) {
                        Write-Host "    ❌ Error: $scpResult" -ForegroundColor Red
                    }
                } catch {
                    Write-Host "    ❌ Error al copiar: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
        } else {
            Write-Host "  ⚠️ $file no encontrado" -ForegroundColor Yellow
        }
    }
    
    if ($requiresRestart -and -not $DryRun) {
        Write-Host "  🔄 Reiniciando contenedores..." -ForegroundColor Blue
        $restartResult = ssh "${VPS_USER}@${VPS_HOST}" "cd $VPS_PATH && docker-compose -f docker-compose.vps.yml restart" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ Contenedores reiniciados" -ForegroundColor Green
        } else {
            Write-Host "  ❌ Error al reiniciar: $restartResult" -ForegroundColor Red
        }
    }
}

# Sincronizar archivos por categorías
Sync-Files $criticalFiles "archivos críticos del frontend" $true
Sync-Files $configFiles "archivos de configuración" $false
Sync-Files $n8nFiles "workflows N8N" $false

# Crear carpetas organizadas en VPS si no existen
if (-not $DryRun) {
    Write-Host "`n📂 Creando estructura de carpetas en VPS..." -ForegroundColor Yellow
    $folders = @("scripts", "tests", "docs", "config")
    foreach ($folder in $folders) {
        ssh "${VPS_USER}@${VPS_HOST}" "mkdir -p ${VPS_PATH}/$folder"
        Write-Host "  ✅ $folder/" -ForegroundColor Green
    }
}

# Verificar estado final
Write-Host "`n🔍 Verificando estado del sistema..." -ForegroundColor Blue
if (-not $DryRun) {
    $statusResult = ssh "${VPS_USER}@${VPS_HOST}" "cd $VPS_PATH && docker-compose -f docker-compose.vps.yml ps"
    Write-Host $statusResult -ForegroundColor White
    
    # Verificar URLs
    Write-Host "`n🌐 Verificando URLs..." -ForegroundColor Blue
    $urls = @{
        "Frontend" = "https://obratec.app"
        "N8N" = "https://n8n.obratec.app"
    }
    
    foreach ($service in $urls.GetEnumerator()) {
        try {
            $response = Invoke-WebRequest -Uri $service.Value -Method Head -TimeoutSec 10 -UseBasicParsing
            Write-Host "  ✅ $($service.Key): $($service.Value)" -ForegroundColor Green
        } catch {
            Write-Host "  ❌ $($service.Key): $($service.Value) (Error: $($_.Exception.Message))" -ForegroundColor Red
        }
    }
}

Write-Host "`n✅ SINCRONIZACIÓN COMPLETADA" -ForegroundColor Green
Write-Host "🎯 Próximos pasos:" -ForegroundColor Blue
Write-Host "  1. Probar sistema en: https://obratec.app" -ForegroundColor White
Write-Host "  2. Verificar N8N en: https://n8n.obratec.app" -ForegroundColor White
Write-Host "  3. Ejecutar pruebas: .\tests\test-sistema-wav.ps1" -ForegroundColor White
