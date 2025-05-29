# Test directo N8N post-reorganización
$webhookUrl = "https://n8n.obratec.app/webhook/form-obra"

$testData = @{
    projectName = "Test Reorganizado"
    date = (Get-Date -Format "yyyy-MM-dd")
    advance = "80"
    observations = "Prueba post-reorganización"
    incidences = "Ninguna"
    audioData = "UklGRiQAAABXQVZFZm10IBAAAAAAAQABAEB3Q="
}

Write-Host "🧪 Probando N8N directo post-reorganización..." -ForegroundColor Green

try {
    $response = Invoke-RestMethod -Uri $webhookUrl -Method POST -Body $testData -ContentType "application/x-www-form-urlencoded" -TimeoutSec 30
    Write-Host "✅ Webhook N8N directo exitoso:" -ForegroundColor Green
    $response | ConvertTo-Json | Write-Host
} catch {
    Write-Host "❌ Error:" $_.Exception.Message -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "Código: $($_.Exception.Response.StatusCode)" -ForegroundColor Yellow
    }
}
