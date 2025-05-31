# Test completo del sistema con conversión WAV
Write-Host "🔧 PRUEBA COMPLETA DEL SISTEMA OBRATEC CON WAV" -ForegroundColor Cyan

$baseUrl = "https://obratec.app"
$n8nUrl = "https://n8n.obratec.app"
$webhookUrl = "$n8nUrl/webhook/form-obra"

# 1. Verificar frontend
Write-Host "`n1️⃣ Verificando frontend..." -ForegroundColor Yellow
try {
    $frontendResponse = Invoke-WebRequest -Uri $baseUrl -Method GET -UseBasicParsing
    if ($frontendResponse.StatusCode -eq 200) {
        Write-Host "✅ Frontend funcionando correctamente" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Error en frontend: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. Verificar N8N
Write-Host "`n2️⃣ Verificando N8N..." -ForegroundColor Yellow
try {
    $n8nResponse = Invoke-WebRequest -Uri $n8nUrl -Method GET -UseBasicParsing
    if ($n8nResponse.StatusCode -eq 200) {
        Write-Host "✅ N8N funcionando correctamente" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Error en N8N: $($_.Exception.Message)" -ForegroundColor Red
}

# 3. Simular envío con audio WAV
Write-Host "`n3️⃣ Simulando envío con audio WAV..." -ForegroundColor Yellow

# Crear archivo WAV de prueba básico
$wavBytes = @(0x52,0x49,0x46,0x46,0x24,0x08,0x00,0x00,0x57,0x41,0x56,0x45,0x66,0x6D,0x74,0x20,0x10,0x00,0x00,0x00,0x01,0x00,0x01,0x00,0x44,0xAC,0x00,0x00,0x88,0x58,0x01,0x00,0x02,0x00,0x10,0x00,0x64,0x61,0x74,0x61,0x00,0x08,0x00,0x00) + (@(0x00) * 2048)
$wavBase64 = [System.Convert]::ToBase64String($wavBytes)

$formData = @{
    projectName = "Proyecto Test WAV"
    date = (Get-Date -Format "yyyy-MM-dd")
    advance = "75"
    observations = "Prueba con audio convertido a WAV"
    incidences = "Ninguna incidencia"
    audioData = $wavBase64
}

try {
    Write-Host "📤 Enviando formulario..." -ForegroundColor Blue
    $response = Invoke-RestMethod -Uri $webhookUrl -Method POST -Body $formData -ContentType "application/x-www-form-urlencoded"
    Write-Host "✅ Formulario enviado exitosamente" -ForegroundColor Green
    Write-Host "📋 Respuesta: $response" -ForegroundColor Blue
} catch {
    Write-Host "❌ Error al enviar formulario: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n✅ PRUEBA COMPLETADA" -ForegroundColor Green
Write-Host "🔗 Accede a N8N: $n8nUrl" -ForegroundColor Blue
Write-Host "📱 Prueba en móvil: $baseUrl" -ForegroundColor Blue
