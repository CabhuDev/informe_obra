# Verificacion del sistema en Render
# URL: https://informe-obra-ai.onrender.com

Write-Host "Verificando tu Sistema de Informes de Obra..." -ForegroundColor Green
Write-Host "URL: https://informe-obra-ai.onrender.com" -ForegroundColor Cyan
Write-Host ""

# Probar URLs principales
$urls = @(
    "https://informe-obra-ai.onrender.com",
    "https://informe-obra-ai.onrender.com/health", 
    "https://informe-obra-ai.onrender.com/webhook/status"
)

foreach ($url in $urls) {
    Write-Host "Probando: $url" -ForegroundColor Yellow
    try {
        $response = Invoke-WebRequest -Uri $url -Method GET -TimeoutSec 10 -UseBasicParsing
        Write-Host "  Estado: $($response.StatusCode) - OK" -ForegroundColor Green
    }
    catch {
        Write-Host "  Error: No responde o esta iniciando" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "URLs de tu sistema:" -ForegroundColor Yellow
Write-Host "  Frontend: https://informe-obra-ai.onrender.com" -ForegroundColor White
Write-Host "  N8N Editor: https://informe-obra-ai.onrender.com/n8n/" -ForegroundColor White
Write-Host "  Webhook: https://informe-obra-ai.onrender.com/webhook/form-obra" -ForegroundColor White
Write-Host ""

Write-Host "Variables de entorno en Render:" -ForegroundColor Yellow
Write-Host "  OPENAI_API_KEY=tu-api-key" -ForegroundColor Gray
Write-Host "  GMAIL_USER=pablo.cabello.hurtafo@gmail.com" -ForegroundColor Gray  
Write-Host "  GMAIL_PASSWORD=contraseña-aplicacion-gmail" -ForegroundColor Gray
Write-Host "  WEBHOOK_URL=https://informe-obra-ai.onrender.com/webhook/form-obra" -ForegroundColor Gray
Write-Host "  N8N_ENCRYPTION_KEY=Wz9gP4tUx93bQ7nCa6yV0eZ2LpR1HsKD" -ForegroundColor Gray
