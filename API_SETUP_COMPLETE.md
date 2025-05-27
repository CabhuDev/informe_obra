# 🤖 Configuración Completa de APIs para N8N

## 🚀 Sistema Avanzado de Informes de Obra

Tu workflow de N8N incluye integraciones con:
- **ChatGPT** - Transcripción de audio
- **Google Drive** - Almacenamiento de informes
- **Gmail** - Envío de emails

---

## 🔑 APIs REQUERIDAS

### 1. OpenAI (ChatGPT)
**Para:** Transcripción de audio a texto

**Configuración:**
1. Ve a [platform.openai.com](https://platform.openai.com)
2. Crea cuenta / Inicia sesión
3. Ve a API Keys → Create new secret key
4. Copia la key (empieza con `sk-`)

**Variable de entorno:**
```
OPENAI_API_KEY=sk-tu-key-aqui
```

**Modelo recomendado:** `whisper-1` para transcripción de audio

### 2. Google Drive API
**Para:** Subir y almacenar informes PDF

**Configuración:**
1. Ve a [Google Cloud Console](https://console.cloud.google.com)
2. Crea proyecto nuevo o selecciona existente
3. Habilita Google Drive API
4. Ve a Credenciales → Crear credenciales → OAuth 2.0
5. Configura pantalla de consentimiento
6. Descarga archivo JSON de credenciales

**Variables de entorno:**
```
GOOGLE_CLIENT_ID=tu-client-id
GOOGLE_CLIENT_SECRET=tu-client-secret
GOOGLE_REDIRECT_URI=https://tu-app.onrender.com/oauth/google/callback
```

### 3. Gmail API
**Para:** Envío automático de emails

**Configuración:**
1. Mismo proyecto en Google Cloud Console
2. Habilita Gmail API
3. Usa mismas credenciales OAuth2
4. O configura contraseña de aplicación

**Variables de entorno:**
```
GMAIL_USER=tu-email@gmail.com
GMAIL_PASSWORD=contraseña-app-gmail
# O para OAuth2:
GMAIL_CLIENT_ID=tu-client-id
GMAIL_CLIENT_SECRET=tu-client-secret
GMAIL_REFRESH_TOKEN=tu-refresh-token
```

---

## 🔧 CONFIGURACIÓN EN RENDER

### Variables de Entorno Completas
```bash
# OpenAI
OPENAI_API_KEY=sk-tu-key-aqui

# Google APIs
GOOGLE_CLIENT_ID=tu-client-id.googleusercontent.com
GOOGLE_CLIENT_SECRET=tu-client-secret
GOOGLE_REDIRECT_URI=https://tu-app.onrender.com/oauth/google/callback

# Gmail
GMAIL_USER=tu-email@gmail.com
GMAIL_PASSWORD=contraseña-app-gmail

# N8N Configuration
N8N_HOST=0.0.0.0
N8N_PROTOCOL=http
WEBHOOK_URL=https://tu-app.onrender.com/webhook/form-obra
NODE_ENV=production

# Optional Security
N8N_USER_MANAGEMENT_DISABLED=true
N8N_DIAGNOSTICS_ENABLED=false
```

---

## 📱 CONFIGURACIÓN PASO A PASO

### Paso 1: OpenAI API
1. Registrarse en OpenAI
2. Verificar cuenta (puede requerir tarjeta)
3. Crear API key
4. Agregar a variables de entorno en Render

### Paso 2: Google Cloud Setup
```bash
# 1. Crear proyecto en Google Cloud
# 2. Habilitar APIs necesarias:
#    - Google Drive API
#    - Gmail API
# 3. Configurar OAuth2 consent screen
# 4. Crear credenciales OAuth2
# 5. Agregar dominios autorizados:
#    - https://tu-app.onrender.com
```

### Paso 3: Configurar N8N Credentials
Una vez desplegado en Render:
1. Ve a `https://tu-app.onrender.com/n8n`
2. Ve a Settings → Credentials
3. Agregar credenciales para cada servicio:

**OpenAI:**
- Tipo: OpenAI
- API Key: Tu key de OpenAI

**Google Drive:**
- Tipo: Google OAuth2 API
- Client ID: Tu Google Client ID
- Client Secret: Tu Google Client Secret

**Gmail:**
- Tipo: Gmail OAuth2 API
- Mismo Client ID y Secret que Drive

---

## 🔄 FLUJO DEL WORKFLOW

```
1. 📱 FORMULARIO WEB
   ↓ (datos + audio + fotos)

2. 🎯 WEBHOOK N8N
   ↓ (recibe datos)

3. 🤖 CHATGPT
   ↓ (transcribe audio)

4. 📄 GENERAR PDF
   ↓ (crear informe)

5. ☁️ GOOGLE DRIVE
   ↓ (subir informe)

6. 📧 GMAIL
   ↓ (enviar email con enlace)

7. ✅ CONFIRMACIÓN
```

---

## 💰 COSTOS ESTIMADOS

### Plan Gratuito
- **Render:** $0/mes (750 horas)
- **Google APIs:** Gratuito (límites generosos)
- **Gmail:** Gratuito (500 emails/día)
- **OpenAI:** $5-10/mes (según uso)

### Límites
- **OpenAI Whisper:** ~$0.006 por minuto de audio
- **Google Drive:** 15GB gratis
- **Gmail:** 500 emails/día gratis

---

## 🛠️ TROUBLESHOOTING

### Error: OpenAI API Key Invalid
- Verifica que la key empiece con `sk-`
- Confirma que tienes créditos en tu cuenta
- Revisa que el modelo `whisper-1` esté disponible

### Error: Google APIs 
- Confirma que las APIs están habilitadas
- Verifica que el dominio esté autorizado
- Checa que las credenciales sean correctas

### Error: Gmail
- Si usas contraseña de aplicación, activa 2FA primero
- Para OAuth2, confirma los scopes necesarios
- Verifica que el usuario tenga permisos

---

## 🎯 ARCHIVO DE CREDENCIALES PARA N8N

Una vez configurado todo, tu N8N tendrá estas credenciales:
- ✅ OpenAI API (para transcripción)
- ✅ Google OAuth2 (para Drive y Gmail)
- ✅ Webhook configurado
- ✅ Templates de email

## 🚀 ¡LISTO PARA PRODUCCIÓN!

Con estas configuraciones, tu sistema podrá:
1. **Recibir formularios** con audio y fotos
2. **Transcribir audio** automáticamente
3. **Generar PDF** profesional
4. **Subir a Drive** para almacenamiento
5. **Enviar email** con enlace al informe
6. **Todo automático** y escalable