# 🔗 TEST WEBHOOK - obratec.app
# Simulacion de envio de formulario para probar el webhook N8N

Write-Host "TESTING WEBHOOK N8N..." -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Blue

$webhookUrl = "https://obratec.app/webhook/form-obra"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Datos de prueba del formulario
$testData = @{
    operario = "Juan Perez (TEST)"
    fecha = (Get-Date -Format "yyyy-MM-dd")
    ubicacion = "Obra Test - Madrid"
    descripcion = "Test de funcionamiento del sistema de informes"
    observaciones = "Prueba automatica del webhook - $timestamp"
    audioTranscription = "Texto de prueba simulando transcripcion de audio: Hola, esto es una prueba del sistema de informes de obra."
    audioFileName = "test_audio_$((Get-Date).Ticks).wav"
} | ConvertTo-Json

Write-Host "📤 ENVIANDO DATOS DE PRUEBA AL WEBHOOK..." -ForegroundColor Yellow
Write-Host "URL: $webhookUrl" -ForegroundColor White
Write-Host ""

try {
    $headers = @{
        "Content-Type" = "application/json"
        "User-Agent" = "ObratecApp-Test/1.0"
    }
    
    $response = Invoke-RestMethod -Uri $webhookUrl -Method POST -Body $testData -Headers $headers -UseBasicParsing
    
    Write-Host "✅ WEBHOOK RESPONDIO EXITOSAMENTE!" -ForegroundColor Green
    Write-Host "Respuesta del servidor:" -ForegroundColor Cyan
    Write-Host ($response | ConvertTo-Json -Depth 3) -ForegroundColor White
    
} catch {
    Write-Host "❌ ERROR EN WEBHOOK:" -ForegroundColor Red
    Write-Host "Codigo de estado: $($_.Exception.Response.StatusCode)" -ForegroundColor Yellow
    Write-Host "Mensaje: $($_.Exception.Message)" -ForegroundColor Yellow
    
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Respuesta del servidor: $responseBody" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "🔍 VERIFICAR EN N8N:" -ForegroundColor Cyan
Write-Host "1. Acceder a https://n8n.obratec.app" -ForegroundColor White
Write-Host "2. Usuario: [VER .env]" -ForegroundColor White  
Write-Host "3. Password: [VER .env]" -ForegroundColor White
Write-Host "4. Ir a 'Executions' para ver el procesamiento" -ForegroundColor White
Write-Host "5. Verificar que el workflow 'obratec-informe Obra' se ejecuto" -ForegroundColor White
Write-Host ""
Write-Host "📧 VERIFICAR EMAIL:" -ForegroundColor Cyan
Write-Host "Revisar la bandeja de entrada para el email automatico" -ForegroundColor White
Write-Host ""
Write-Host "===============================================" -ForegroundColor Blue
