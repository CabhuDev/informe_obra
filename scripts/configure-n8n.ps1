# =================================================================
# SCRIPT DE CONFIGURACION N8N - obratec.app
# =================================================================

Write-Host "CONFIGURANDO N8N PARA SISTEMA DE INFORMES DE OBRA" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Blue

# Variables de configuracion
$N8N_URL = "https://n8n.obratec.app"
$N8N_USER = "[VER .env - N8N_BASIC_AUTH_USER]"
$N8N_PASSWORD = "[VER .env - N8N_BASIC_AUTH_PASSWORD]"

Write-Host "PASOS A SEGUIR:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Acceder a N8N:" -ForegroundColor Cyan
Write-Host "   URL: $N8N_URL" -ForegroundColor White
Write-Host "   Usuario: $N8N_USER" -ForegroundColor White
Write-Host "   Password: $N8N_PASSWORD" -ForegroundColor White
Write-Host ""

Write-Host "2. Configurar credenciales de Gmail OAuth2:" -ForegroundColor Cyan
Write-Host "   - Ir a Settings > Credentials" -ForegroundColor White
Write-Host "   - Crear nueva credencial: Google OAuth2 API" -ForegroundColor White
Write-Host "   - Client ID: [VER .env.example - GOOGLE_OAUTH_CLIENT_ID]" -ForegroundColor Yellow
Write-Host "   - Client Secret: [VER .env.example - GOOGLE_OAUTH_CLIENT_SECRET]" -ForegroundColor Yellow
Write-Host "   - Scope: https://www.googleapis.com/auth/gmail.send" -ForegroundColor White
Write-Host ""

Write-Host "3. Importar workflow:" -ForegroundColor Cyan
Write-Host "   - Ir a Workflows > Import" -ForegroundColor White
Write-Host "   - Cargar: n8n/workflows/informe_obra_n8n_workflow.json" -ForegroundColor White
Write-Host ""

Write-Host "4. Configurar credenciales en workflow:" -ForegroundColor Cyan
Write-Host "   - Abrir el workflow importado" -ForegroundColor White
Write-Host "   - En el nodo Gmail: asignar las credenciales OAuth2 creadas" -ForegroundColor White
Write-Host "   - En el nodo OpenAI: crear credencial con API Key" -ForegroundColor White
Write-Host ""

Write-Host "5. Activar workflow:" -ForegroundColor Cyan
Write-Host "   - Hacer clic en 'Active' para activar el workflow" -ForegroundColor White
Write-Host ""

Write-Host "6. Probar sistema completo:" -ForegroundColor Cyan
Write-Host "   - Acceder a: https://obratec.app" -ForegroundColor White
Write-Host "   - Probar grabacion de audio (especialmente en iPhone)" -ForegroundColor White
Write-Host "   - Enviar formulario y verificar recepcion de email" -ForegroundColor White
Write-Host ""

Write-Host "=================================================================" -ForegroundColor Blue

# Abrir las URLs necesarias
Write-Host "Abriendo URLs necesarias..." -ForegroundColor Green
Start-Process "https://n8n.obratec.app"
Start-Sleep -Seconds 2
Start-Process "https://obratec.app"

Write-Host ""
Write-Host "URLs abiertas en el navegador." -ForegroundColor Green
Write-Host "Recuerda probar especialmente en iPhone/Safari para verificar la grabacion de audio." -ForegroundColor Yellow
Write-Host ""
Write-Host "OBJETIVO: Sistema completo funcionando end-to-end con grabacion de audio compatible con iOS" -ForegroundColor Magenta
