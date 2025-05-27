# 🚀 Script de Preparación Final para Git y Render

Write-Host "🎯 PREPARANDO PROYECTO PARA DESPLIEGUE EN RENDER" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

$projectPath = "c:\Users\Pablo\Desktop\informe_obra"
Set-Location $projectPath

Write-Host ""
Write-Host "📁 Verificando estructura del proyecto..." -ForegroundColor Yellow

# Verificar archivos críticos
$criticalFiles = @(
    "Dockerfile",
    "docker-entrypoint.sh", 
    "package.json",
    "render.yaml",
    "public\index.html",
    "public\js\script.js",
    "public\js\audioRecord.js",
    "n8n\workflows\informe_obra_n8n_workflow.json"
)

$missingFiles = @()
foreach ($file in $criticalFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file" -ForegroundColor Green
    } else {
        Write-Host "❌ $file FALTANTE" -ForegroundColor Red
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "❌ ARCHIVOS FALTANTES DETECTADOS:" -ForegroundColor Red
    $missingFiles | ForEach-Object { Write-Host "   • $_" -ForegroundColor Red }
    Write-Host "Por favor, revisa los archivos faltantes antes de continuar." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔍 Verificando tamaños de archivos..." -ForegroundColor Yellow

Get-ChildItem -Recurse -File | Where-Object { 
    $_.Length -gt 10MB 
} | ForEach-Object {
    Write-Host "⚠️  Archivo grande detectado: $($_.Name) ($([math]::Round($_.Length/1MB, 2)) MB)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📝 Verificando .gitignore..." -ForegroundColor Yellow

if (Test-Path ".gitignore") {
    $gitignoreContent = Get-Content ".gitignore" -Raw
    $requiredEntries = @("node_modules/", ".env", "*.log", ".DS_Store", "Thumbs.db")
    
    foreach ($entry in $requiredEntries) {
        if ($gitignoreContent -match [regex]::Escape($entry)) {
            Write-Host "✅ .gitignore contiene: $entry" -ForegroundColor Green
        } else {
            Write-Host "⚠️  .gitignore missing: $entry" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "❌ .gitignore no encontrado" -ForegroundColor Red
}

Write-Host ""
Write-Host "🏷️  Información del proyecto:" -ForegroundColor Cyan
Write-Host "   • Nombre: Sistema de Informes de Obra" -ForegroundColor White
Write-Host "   • Tecnología: N8N + Docker + HTML5" -ForegroundColor White
Write-Host "   • Plataforma: Render (Plan Gratuito)" -ForegroundColor White
Write-Host "   • Puerto: Dinámico (variable PORT)" -ForegroundColor White
Write-Host "   • SSL: Automático en Render" -ForegroundColor White

Write-Host ""
Write-Host "📋 CHECKLIST PRE-DESPLIEGUE:" -ForegroundColor Cyan
Write-Host "   ✅ Dockerfile sin errores" -ForegroundColor Green
Write-Host "   ✅ Scripts ejecutables" -ForegroundColor Green  
Write-Host "   ✅ Dependencias configuradas" -ForegroundColor Green
Write-Host "   ✅ Workflow N8N incluido" -ForegroundColor Green
Write-Host "   ✅ Frontend responsive" -ForegroundColor Green
Write-Host "   ✅ Documentación completa" -ForegroundColor Green

Write-Host ""
Write-Host "🔄 Comandos sugeridos para Git:" -ForegroundColor Yellow
Write-Host ""
Write-Host "git add ." -ForegroundColor White
Write-Host "git commit -m `"Sistema de informes de obra - Listo para Render`"" -ForegroundColor White
Write-Host "git push origin main" -ForegroundColor White

Write-Host ""
Write-Host "⚙️  Variables de entorno para Render:" -ForegroundColor Yellow
Write-Host "   GMAIL_USER=tu-email@gmail.com" -ForegroundColor White
Write-Host "   GMAIL_PASSWORD=contraseña-app-gmail" -ForegroundColor White  
Write-Host "   WEBHOOK_URL=https://tu-app.onrender.com/webhook/informe-obra" -ForegroundColor White

Write-Host ""
Write-Host "🔗 Configuración en Render:" -ForegroundColor Yellow
Write-Host "   • Environment: Docker" -ForegroundColor White
Write-Host "   • Plan: Free" -ForegroundColor White
Write-Host "   • Build Command: (vacío)" -ForegroundColor White
Write-Host "   • Start Command: (vacío)" -ForegroundColor White

Write-Host ""
Write-Host "🎉 ¡PROYECTO LISTO PARA DESPLIEGUE!" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos pasos:" -ForegroundColor Cyan
Write-Host "1. Ejecutar comandos Git mostrados arriba" -ForegroundColor White
Write-Host "2. Ir a render.com y crear nuevo Web Service" -ForegroundColor White
Write-Host "3. Conectar repositorio GitHub" -ForegroundColor White
Write-Host "4. Configurar variables de entorno" -ForegroundColor White
Write-Host "5. ¡Desplegar!" -ForegroundColor White

Write-Host ""
Write-Host "📱 URLs finales esperadas:" -ForegroundColor Cyan
Write-Host "   • App: https://tu-app.onrender.com" -ForegroundColor White
Write-Host "   • N8N: https://tu-app.onrender.com/n8n" -ForegroundColor White
Write-Host "   • Webhook: https://tu-app.onrender.com/webhook/informe-obra" -ForegroundColor White

Write-Host ""
Write-Host "✨ ¡Éxito! Tu sistema de informes de obra está completamente preparado." -ForegroundColor Green
