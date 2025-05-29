#!/usr/bin/env powershell
# Gestor del Proyecto Obratec
# Script para facilitar tareas comunes del proyecto

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("start", "test", "deploy", "clean", "status", "help")]
    [string]$Action,
    
    [string]$Environment = "development"
)

$ProjectRoot = $PSScriptRoot
$ProjectName = "Obratec - Sistema de Informes"

Write-Host "🏗️ $ProjectName" -ForegroundColor Cyan
Write-Host "Acción: $Action | Entorno: $Environment" -ForegroundColor Blue
Write-Host "=================================" -ForegroundColor Gray

switch ($Action) {
    "start" {
        Write-Host "🚀 Iniciando servidor de desarrollo..." -ForegroundColor Green
        Set-Location $ProjectRoot
        npm start
    }
    
    "test" {
        Write-Host "🧪 Ejecutando pruebas del sistema..." -ForegroundColor Yellow
        Set-Location "$ProjectRoot\tests"
        .\test-sistema-wav.ps1
    }
    
    "deploy" {
        Write-Host "🚢 Desplegando en VPS..." -ForegroundColor Magenta
        Set-Location "$ProjectRoot\deploy"
        if ($Environment -eq "production") {
            .\deploy-vps.sh
        } else {
            Write-Host "⚠️ Especifica -Environment production para desplegar" -ForegroundColor Yellow
        }
    }
    
    "clean" {
        Write-Host "🧹 Limpiando archivos temporales..." -ForegroundColor Blue
        Set-Location $ProjectRoot
        Remove-Item "node_modules" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "*.log" -Force -ErrorAction SilentlyContinue
        npm install
        Write-Host "✅ Limpieza completada" -ForegroundColor Green
    }
    
    "status" {
        Write-Host "📊 Estado del proyecto:" -ForegroundColor Blue
        Write-Host ""
        
        # Verificar archivos principales
        $mainFiles = @("server.js", "package.json", ".env")
        foreach ($file in $mainFiles) {
            $exists = Test-Path "$ProjectRoot\$file"
            $status = if ($exists) { "✅" } else { "❌" }
            Write-Host "  $status $file" -ForegroundColor White
        }
        
        # Verificar estructura de carpetas
        Write-Host ""
        Write-Host "📁 Estructura de carpetas:" -ForegroundColor Blue
        $folders = @("public", "n8n", "deploy", "config", "scripts", "tests", "docs")
        foreach ($folder in $folders) {
            $exists = Test-Path "$ProjectRoot\$folder"
            $status = if ($exists) { "✅" } else { "❌" }
            $count = if ($exists) { " ($(Get-ChildItem $ProjectRoot\$folder | Measure-Object | Select-Object -ExpandProperty Count) archivos)" } else { "" }
            Write-Host "  $status $folder$count" -ForegroundColor White
        }
        
        # Verificar URLs si están disponibles
        Write-Host ""
        Write-Host "🌐 URLs del sistema:" -ForegroundColor Blue
        $urls = @{
            "Frontend" = "https://obratec.app"
            "N8N" = "https://n8n.obratec.app"
        }
        
        foreach ($service in $urls.GetEnumerator()) {
            try {
                $response = Invoke-WebRequest -Uri $service.Value -Method Head -TimeoutSec 5 -UseBasicParsing
                Write-Host "  ✅ $($service.Key): $($service.Value)" -ForegroundColor Green
            } catch {
                Write-Host "  ❌ $($service.Key): $($service.Value) (No disponible)" -ForegroundColor Red
            }
        }
    }
    
    "help" {
        Write-Host "📖 Comandos disponibles:" -ForegroundColor Blue
        Write-Host ""
        Write-Host "  .\manage.ps1 start" -ForegroundColor White
        Write-Host "    Inicia el servidor de desarrollo" -ForegroundColor Gray
        Write-Host ""
        Write-Host "  .\manage.ps1 test" -ForegroundColor White
        Write-Host "    Ejecuta las pruebas del sistema" -ForegroundColor Gray
        Write-Host ""
        Write-Host "  .\manage.ps1 deploy -Environment production" -ForegroundColor White
        Write-Host "    Despliega el sistema en VPS" -ForegroundColor Gray
        Write-Host ""
        Write-Host "  .\manage.ps1 clean" -ForegroundColor White
        Write-Host "    Limpia y reinstala dependencias" -ForegroundColor Gray
        Write-Host ""
        Write-Host "  .\manage.ps1 status" -ForegroundColor White
        Write-Host "    Muestra el estado del proyecto y servicios" -ForegroundColor Gray
        Write-Host ""
        Write-Host "📁 Estructura del proyecto:" -ForegroundColor Blue
        Write-Host "  public/    - Frontend de la aplicación" -ForegroundColor Gray
        Write-Host "  n8n/       - Workflows de automatización" -ForegroundColor Gray
        Write-Host "  deploy/    - Archivos de despliegue" -ForegroundColor Gray
        Write-Host "  config/    - Configuraciones del sistema" -ForegroundColor Gray
        Write-Host "  scripts/   - Scripts de automatización" -ForegroundColor Gray
        Write-Host "  tests/     - Pruebas del sistema" -ForegroundColor Gray
        Write-Host "  docs/      - Documentación" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "✅ Acción '$Action' completada" -ForegroundColor Green
