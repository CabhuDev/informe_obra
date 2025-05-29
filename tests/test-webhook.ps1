# Test script para probar el webhook del sistema de informes
$testData = @{
    projectName = "Proyecto Test Obratec"
    date = "28/05/2025"
    advance = "75"
    observations = "Prueba del sistema de informes automático. Todas las funcionalidades están operativas."
    incidences = "No se han registrado incidencias durante esta prueba."
    audioTranscription = "Esta es una transcripción de prueba del audio grabado para el informe de obra."
} | ConvertTo-Json

$headers = @{
    'Content-Type' = 'application/json'
}

try {
    Write-Host "🚀 Enviando datos de prueba al webhook..." -ForegroundColor Green
    Write-Host "URL: https://obratec.app/webhook/form-obra" -ForegroundColor Yellow
    
    $response = Invoke-WebRequest -Uri "https://obratec.app/webhook/form-obra" -Method POST -Body $testData -Headers $headers -UseBasicParsing
    
    Write-Host "✅ Respuesta del servidor:" -ForegroundColor Green
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Cyan
    Write-Host "Response Body: $($response.Content)" -ForegroundColor White
    
} catch {
    Write-Host "❌ Error al enviar la solicitud:" -ForegroundColor Red
    Write-Host "$($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Response) {
        $reader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Respuesta del servidor: $responseBody" -ForegroundColor Yellow
    }
}
