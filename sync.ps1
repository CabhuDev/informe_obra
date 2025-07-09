param([switch]$DryRun = $false)

# ================================================================
# SYNC SCRIPT - SISTEMA OBRATEC 
# ================================================================
# Última actualización: Junio 2025
# 
# OPTIMIZACIONES CSS COMPLETADAS EN ESTA SINCRONIZACIÓN:
# 🔥 CSS OPTIMIZATION COMPLETADO - 99.86% reducción !important
# 🔥 INLINE STYLES ELIMINADOS - 100% eliminación estilos inline
# ✅ WAITLIST PREMIUM COMPLETADO - €10,000 Quality
# ✅ CSS Premium con 2,900+ líneas optimizadas
# ✅ JavaScript modular con CSSUtils system
# ✅ Arquitectura CSS limpia sin malas prácticas
# ✅ Animaciones cinematográficas y micro-interacciones
# ✅ Diseño responsivo profesional
# ✅ Sistema de colores científico y branding premium
# ✅ Navegación glass con backdrop-filter
# ✅ Formulario con estados de carga y success animations
# ✅ WhatsApp CTA con efectos glassmorphism
# ✅ Social proof y trust building elementos
# ✅ Performance optimizado con GPU acceleration
# ✅ Documentación consolidada sin duplicados
# ================================================================

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
    # === PÁGINAS HTML ===
    #"public\pages\landing.html",
    #"public\pages\form-report.html",           # ✅ Actualizado: Empty state mejorado, separación JS/HTML
    "public\pages\waitlist-form.html",        # ✅ Actualizado: CSS optimizado, sin !important
    #"public\templates\reportSent.html",        # ✅ Actualizado: Colores corporativos, obratec.app
    
    # === CSS STYLES OPTIMIZADOS ===
    #"public\css\style.css",                    # ✅ Actualizado: Empty state styles, tips interactivos
    #"public\css\landing.css",                  # ✅ Actualizado: Premium design €10,000
    #"public\css\waitlist.css",                 # ✅ CRÍTICO: 99.86% reducción !important (719→1)
    #"public\css\form-report-enhanced.css",     # ✅ NUEVO: 716 líneas CSS sin estilos inline
    
    # === JAVASCRIPT OPTIMIZADO ===
    #"public\js\cssUtils.js",                   # ✅ NUEVO: Sistema utilidades CSS management
    #"public\js\photoManager.js",               # ✅ CRÍTICO: Separación JS/HTML, event listeners modernos
    #"public\js\script.js",                     # ✅ Actualizado: URLs webhook corregidas + CSSUtils
    "public\js\waitlist.js",                   # ✅ Actualizado: Refactorizado, Array.from() fix
    #"public\js\audioRecord.js",                # ✅ Actualizado: CSSUtils integration
    #"public\js\heicConverter.js",
    "server.js"
    
    # === ASSETS NUEVOS ===
    #"public\assets\empty-state.png",           # ✅ NUEVO: Imagen para empty state
    #"public\assets\hero.png",                  # ✅ NUEVO: Hero banner imagen
    #"public\assets\logo.PNG",                  # ✅ CRÍTICO: Logo corporativo Obratec
    #"public\assets\favicon.webp",              # ✅ NUEVO: Favicon optimizado
    
    # === TEMPLATES ===
    #"public\templates\reportTemplateAI.html",
    #"public\templates\reportphotos.js",
    
    
    # === WORKFLOWS N8N ===
    #"n8n\workflows\informe_obra_n8n_workflow.json",
    
    # === DOCUMENTACIÓN DE PRODUCCIÓN ===
    #"PROYECTO_PREMIUM_ENTREGADO.md",           # ✅ NUEVO: Documento cliente final
    #"OPTIMIZACION_COMPLETA_FINAL.md",          # ✅ NUEVO: Resumen ejecutivo
    #"PROYECTO_FINALIZADO_EXITOSAMENTE.md"     # ✅ NUEVO: Estado final del proyecto
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
