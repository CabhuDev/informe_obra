# Script de verificación para tu sistema desplegado en Render
# URL: https://informe-obra-ai.onrender.com

Write-Host "Verificando tu Sistema de Informes de Obra en Render..." -ForegroundColor Green
Write-Host "URL: https://informe-obra-ai.onrender.com" -ForegroundColor Cyan
Write-Host ""

# Función para probar URLs
function Test-Url {
    param([string]$url, [string]$description)
    
    try {
        Write-Host "Probando $description..." -ForegroundColor Yellow -NoNewline
        $response = Invoke-WebRequest -Uri $url -Method GET -TimeoutSec 30 -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host " ✓ OK" -ForegroundColor Green
            return $true
        } else {
            Write-Host " ✗ Error (Código: $($response.StatusCode))" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host " ✗ Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

Write-Host "Probando endpoints de tu sistema..." -ForegroundColor Cyan
Write-Host ""

# URLs específicas de tu sistema
$urls = @(
    @{url="https://informe-obra-ai.onrender.com"; desc="Frontend (Formulario)"},
    @{url="https://informe-obra-ai.onrender.com/health"; desc="Health Check"},
    @{url="https://informe-obra-ai.onrender.com/webhook/status"; desc="Webhook Status"},
    @{url="https://informe-obra-ai.onrender.com/n8n/"; desc="N8N Editor"}
)

$allOk = $true

foreach ($test in $urls) {
    $result = Test-Url -url $test.url -description $test.desc
    if (-not $result) { $allOk = $false }
    Start-Sleep -Seconds 1
}

Write-Host ""

if ($allOk) {
    Write-Host "🎉 ¡Todo funcionando correctamente!" -ForegroundColor Green
    Write-Host ""
    Write-Host "URLs de tu sistema:" -ForegroundColor Yellow
    Write-Host "  📱 Formulario: https://informe-obra-ai.onrender.com" -ForegroundColor White
    Write-Host "  ⚙️  N8N Editor: https://informe-obra-ai.onrender.com/n8n/" -ForegroundColor White
    Write-Host "  🔗 Webhook: https://informe-obra-ai.onrender.com/webhook/form-obra" -ForegroundColor White
    Write-Host ""    Write-Host "Variables de entorno que debes configurar en Render:" -ForegroundColor Yellow
    Write-Host "  OPENAI_API_KEY=tu-clave-openai-aqui" -ForegroundColor Gray
    Write-Host "  GMAIL_USER=tu-email@gmail.com" -ForegroundColor Gray
    Write-Host "  GMAIL_PASSWORD=tu-contraseña-aplicacion-gmail" -ForegroundColor Gray
    Write-Host "  WEBHOOK_URL=https://informe-obra-ai.onrender.com/webhook/form-obra" -ForegroundColor Gray
    Write-Host "  N8N_ENCRYPTION_KEY=Wz9gP4tUx93bQ7nCa6yV0eZ2LpR1HsKD" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📖 Consulta TU_SISTEMA_CONFIGURADO.md para más detalles" -ForegroundColor Cyan
} else {
    Write-Host "⚠️  Algunos servicios no responden" -ForegroundColor Yellow
    Write-Host "Esto puede ser normal si Render está iniciando los contenedores" -ForegroundColor Yellow
    Write-Host "Espera 2-3 minutos y vuelve a probar" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Si persisten los errores:" -ForegroundColor Red
    Write-Host "1. Verifica las variables de entorno en Render dashboard" -ForegroundColor White
    Write-Host "2. Revisa los logs en Render dashboard" -ForegroundColor White
    Write-Host "3. Asegurate de que el build se completó correctamente" -ForegroundColor White
}

Write-Host ""
Write-Host "Para obtener contraseña de Gmail:" -ForegroundColor Yellow
Write-Host "1. Ve a: https://myaccount.google.com" -ForegroundColor Gray
Write-Host "2. Seguridad → Verificación en 2 pasos → Contraseñas de aplicaciones" -ForegroundColor Gray
Write-Host "3. Generar nueva contraseña para 'Sistema de informes'" -ForegroundColor Gray
