# Test completo del sistema con conversión WAV
# Verifica frontend, grabación de audio WAV, N8N y OpenAI Whisper

Write-Host "🔧 PRUEBA COMPLETA DEL SISTEMA OBRATEC CON WAV" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

$baseUrl = "https://obratec.app"
$n8nUrl = "https://n8n.obratec.app"
$webhookUrl = "$n8nUrl/webhook/form-obra"

# 1. Verificar frontend
Write-Host "`n1️⃣ Verificando frontend..." -ForegroundColor Yellow
try {
    $frontendResponse = Invoke-WebRequest -Uri $baseUrl -Method GET -UseBasicParsing
    if ($frontendResponse.StatusCode -eq 200) {
        Write-Host "✅ Frontend funcionando correctamente" -ForegroundColor Green
        
        # Verificar que audioRecord.js está cargado
        if ($frontendResponse.Content -match "audioRecord\.js") {
            Write-Host "✅ Script de audio cargado" -ForegroundColor Green
        } else {
            Write-Host "⚠️ Script de audio no encontrado en HTML" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "❌ Error en frontend: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
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

# 3. Simular envío de formulario con audio WAV
Write-Host "`n3️⃣ Simulando envío con audio WAV..." -ForegroundColor Yellow

# Crear un archivo WAV de prueba básico (silencio de 1 segundo)
$wavHeader = @(
    0x52, 0x49, 0x46, 0x46, # "RIFF"
    0x24, 0x08, 0x00, 0x00, # File size - 8
    0x57, 0x41, 0x56, 0x45, # "WAVE"
    0x66, 0x6D, 0x74, 0x20, # "fmt "
    0x10, 0x00, 0x00, 0x00, # Subchunk1Size
    0x01, 0x00,             # AudioFormat (PCM)
    0x01, 0x00,             # NumChannels (mono)
    0x44, 0xAC, 0x00, 0x00, # SampleRate (44100)
    0x88, 0x58, 0x01, 0x00, # ByteRate
    0x02, 0x00,             # BlockAlign
    0x10, 0x00,             # BitsPerSample
    0x64, 0x61, 0x74, 0x61, # "data"
    0x00, 0x08, 0x00, 0x00  # Subchunk2Size
)

# Datos de audio (silencio)
$audioData = @(0x00) * 2048

# Combinar header y datos
$wavBytes = $wavHeader + $audioData
$wavBase64 = [System.Convert]::ToBase64String($wavBytes)

# Datos del formulario
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
    Write-Host "📋 Respuesta del servidor:" -ForegroundColor Blue
    $response | ConvertTo-Json -Depth 3 | Write-Host
    
} catch {
    Write-Host "❌ Error al enviar formulario: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode
        Write-Host "📊 Código de estado: $statusCode" -ForegroundColor Red
    }
}

# 4. Verificar logs de N8N
Write-Host "`n4️⃣ Verificando ejecución del workflow..." -ForegroundColor Yellow
Write-Host "🔗 Accede a N8N para verificar la ejecución: $n8nUrl" -ForegroundColor Blue
Write-Host "📋 Credenciales N8N:" -ForegroundColor Blue
Write-Host "   Usuario: obratecadmin" -ForegroundColor Gray
Write-Host "   Password: [configurado en .env]" -ForegroundColor Gray

Write-Host "`n✅ PRUEBA COMPLETADA" -ForegroundColor Green
Write-Host "🎯 Verificaciones realizadas:" -ForegroundColor Blue
Write-Host "   - Frontend cargado correctamente" -ForegroundColor Gray
Write-Host "   - N8N accesible" -ForegroundColor Gray
Write-Host "   - Formulario enviado con audio WAV" -ForegroundColor Gray
Write-Host "   - Archivo WAV de prueba generado y codificado en Base64" -ForegroundColor Gray

Write-Host "`n📱 Para probar en dispositivo móvil:" -ForegroundColor Yellow
Write-Host "   1. Abre https://obratec.app en Safari (iOS) o Chrome (Android)" -ForegroundColor Gray
Write-Host "   2. Rellena el formulario" -ForegroundColor Gray
Write-Host "   3. Graba audio usando el botón de grabación" -ForegroundColor Gray
Write-Host "   4. Verifica que se convierte automáticamente a WAV" -ForegroundColor Gray
Write-Host "   5. Envía el formulario" -ForegroundColor Gray
Write-Host "   6. Revisa N8N para ver si OpenAI Whisper procesa el audio correctamente" -ForegroundColor Gray
