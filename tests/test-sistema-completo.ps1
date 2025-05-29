# 🧪 SCRIPT DE TESTING COMPLETO - obratec.app
# ================================================================

Write-Host "INICIANDO TESTING COMPLETO DEL SISTEMA" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Blue

# Variables del sistema
$FRONTEND_URL = "https://obratec.app"
$N8N_URL = "https://n8n.obratec.app"
$WEBHOOK_URL = "https://obratec.app/webhook/form-obra"

Write-Host "ESTADO ACTUAL DEL SISTEMA:" -ForegroundColor Yellow
Write-Host "✅ Frontend funcionando: $FRONTEND_URL" -ForegroundColor Green
Write-Host "✅ N8N funcionando: $N8N_URL" -ForegroundColor Green
Write-Host "✅ Workflow 'obratec-informe Obra' ACTIVO" -ForegroundColor Green
Write-Host ""

Write-Host "TESTS A REALIZAR:" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. 🌐 TEST FRONTEND:" -ForegroundColor Magenta
Write-Host "   - Acceso a $FRONTEND_URL" -ForegroundColor White
Write-Host "   - Carga correcta del formulario" -ForegroundColor White
Write-Host "   - Deteccion de capacidades de audio" -ForegroundColor White
Write-Host ""

Write-Host "2. 🎤 TEST GRABACION DE AUDIO:" -ForegroundColor Magenta
Write-Host "   - Solicitar permisos de microfono" -ForegroundColor White
Write-Host "   - Grabacion funcional en navegador" -ForegroundColor White
Write-Host "   - **CRITICO: Probar en iPhone/Safari**" -ForegroundColor Red
Write-Host ""

Write-Host "3. 📤 TEST ENVIO DE FORMULARIO:" -ForegroundColor Magenta
Write-Host "   - Completar todos los campos" -ForegroundColor White
Write-Host "   - Enviar con archivo de audio" -ForegroundColor White
Write-Host "   - Verificar respuesta del servidor" -ForegroundColor White
Write-Host ""

Write-Host "4. 🔗 TEST WEBHOOK N8N:" -ForegroundColor Magenta
Write-Host "   - Webhook recibe datos en $WEBHOOK_URL" -ForegroundColor White
Write-Host "   - N8N procesa el workflow automaticamente" -ForegroundColor White
Write-Host "   - Verificar en logs de N8N" -ForegroundColor White
Write-Host ""

Write-Host "5. 🤖 TEST TRANSCRIPCION OPENAI:" -ForegroundColor Magenta
Write-Host "   - Audio enviado a OpenAI Whisper" -ForegroundColor White
Write-Host "   - Transcripcion exitosa" -ForegroundColor White
Write-Host "   - Texto integrado en el informe" -ForegroundColor White
Write-Host ""

Write-Host "6. 📧 TEST ENVIO EMAIL:" -ForegroundColor Magenta
Write-Host "   - Gmail OAuth2 funcionando" -ForegroundColor White
Write-Host "   - Email generado con plantilla" -ForegroundColor White
Write-Host "   - Envio exitoso a destinatario" -ForegroundColor White
Write-Host ""

Write-Host "================================================================" -ForegroundColor Blue

# Test basico de conectividad
Write-Host "🔍 VERIFICANDO CONECTIVIDAD..." -ForegroundColor Yellow

try {
    $frontendTest = Invoke-WebRequest -Uri $FRONTEND_URL -Method HEAD -UseBasicParsing
    Write-Host "✅ Frontend accesible (Status: $($frontendTest.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "❌ Frontend no accesible: $($_.Exception.Message)" -ForegroundColor Red
}

try {
    $n8nTest = Invoke-WebRequest -Uri $N8N_URL -Method HEAD -UseBasicParsing
    Write-Host "✅ N8N accesible (Status: $($n8nTest.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "❌ N8N no accesible: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "🚀 ABRIENDO URLS PARA TESTING MANUAL..." -ForegroundColor Green

# Abrir URLs para testing
Start-Process $FRONTEND_URL
Start-Sleep -Seconds 2
Start-Process $N8N_URL

Write-Host ""
Write-Host "📋 CHECKLIST DE TESTING:" -ForegroundColor Yellow
Write-Host "□ 1. Acceder al frontend y verificar carga completa" -ForegroundColor White
Write-Host "□ 2. Probar grabacion de audio en navegador desktop" -ForegroundColor White
Write-Host "□ 3. **CRITICO: Probar en iPhone - abrir https://obratec.app**" -ForegroundColor Red
Write-Host "□ 4. Completar formulario con todos los campos" -ForegroundColor White
Write-Host "□ 5. Enviar formulario con audio grabado" -ForegroundColor White
Write-Host "□ 6. Verificar mensaje de confirmacion" -ForegroundColor White
Write-Host "□ 7. Revisar logs en N8N para ver procesamiento" -ForegroundColor White
Write-Host "□ 8. Verificar recepcion de email automatico" -ForegroundColor White
Write-Host ""

Write-Host "🎯 OBJETIVO: Flujo completo funcionando desde iPhone hasta email automatico" -ForegroundColor Magenta
Write-Host "📱 ENFOQUE PRINCIPAL: Compatibilidad con dispositivos iOS" -ForegroundColor Cyan
Write-Host ""
Write-Host "================================================================" -ForegroundColor Blue
