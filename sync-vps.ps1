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

# Función para sincronizar archivos
function Sync-Files {
    param($fileList, $description)
    
    Write-Host "📁 Sincronizando $description..." -ForegroundColor Yellow
    
    $requiresRestart = $false
    
    foreach ($file in $fileList) {
        if (Test-Path $file) {
            $relativePath = $file -replace '\\', '/'
            Write-Host "  ✅ $relativePath" -ForegroundColor Green
            
            # Verificar si es un archivo crítico
            if ($criticalFiles -contains $file) {
                $requiresRestart = $true
            }
            
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
        $restartResult = ssh "${VPS_USER}@${VPS_HOST}" "cd $VPS_PATH; docker-compose -f docker-compose.vps.yml restart" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ Contenedores reiniciados" -ForegroundColor Green
        } else {
            Write-Host "  ❌ Error al reiniciar: $restartResult" -ForegroundColor Red
        }
    }
    Write-Host ""
}

# Ejecutar sincronización
Sync-Files $criticalFiles "archivos críticos"
Sync-Files $configFiles "configuración"
Sync-Files $n8nFiles "workflows N8N"

# Verificar estado final
Write-Host "📊 Estado de contenedores en VPS:" -ForegroundColor Blue
if (-not $DryRun) {
    $statusResult = ssh "${VPS_USER}@${VPS_HOST}" "cd $VPS_PATH; docker-compose -f docker-compose.vps.yml ps"
    Write-Host $statusResult -ForegroundColor White
    
    # Verificar URLs
    Write-Host "`n🌐 Verificando URLs..." -ForegroundColor Blue
    
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
}

Write-Host "`n✅ Sincronización completada!" -ForegroundColor Green
Write-Host "💡 Para probar el sistema: .\manage.ps1 test" -ForegroundColor Cyan
