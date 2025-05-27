# 🚀 Guía de Despliegue Avanzado - Sistema de Informes con IA

## 🎯 Tu Sistema Incluye:
- **📱 Formulario web** con grabación de audio
- **🤖 ChatGPT** para transcripción automática
- **☁️ Google Drive** para almacenar informes
- **📧 Gmail** para envío automático
- **🐳 Docker** desplegado en Render

---

## 🔑 PASO 1: Configurar APIs Necesarias

### OpenAI API (ChatGPT)
1. Ve a [platform.openai.com](https://platform.openai.com)
2. Registrarse / Iniciar sesión
3. Ve a "API Keys" → "Create new secret key"
4. Copia la key (empieza con `sk-`)
5. **Importante:** Agrega créditos a tu cuenta ($5-10 recomendado)

### Google Cloud Console
1. Ve a [console.cloud.google.com](https://console.cloud.google.com)
2. Crea un proyecto nuevo: "Informe Obra App"
3. Habilita estas APIs:
   - **Google Drive API**
   - **Gmail API**
4. Ve a "Credenciales" → "Crear credenciales" → "ID de cliente OAuth 2.0"
5. Configura pantalla de consentimiento OAuth
6. Agrega estos URLs autorizados:
   ```
   https://tu-app.onrender.com
   https://tu-app.onrender.com/oauth/google/callback
   ```
7. Descarga el archivo JSON con credenciales

### Gmail - Contraseña de Aplicación
1. Ve a tu cuenta de Google
2. Activa la autenticación de 2 factores
3. Ve a "Contraseñas de aplicaciones"
4. Genera una nueva para "N8N App"
5. Guarda la contraseña de 16 caracteres

---

## 🚀 PASO 2: Desplegar en Render

### 2.1 Subir a GitHub
```powershell
git add .
git commit -m "Sistema de informes con ChatGPT, Drive y Gmail"
git push origin main
```

### 2.2 Crear Servicio en Render
1. Ve a [render.com](https://render.com) → "New" → "Web Service"
2. Conecta tu repositorio de GitHub
3. Configuración:
   - **Name:** `informe-obra-ai`
   - **Environment:** Docker
   - **Plan:** Free
   - **Region:** Oregon (US West)

### 2.3 Variables de Entorno en Render
En la sección "Environment", agrega:

```bash
# OpenAI
OPENAI_API_KEY=sk-tu-key-de-openai-aqui

# Google APIs  
GOOGLE_CLIENT_ID=tu-client-id.googleusercontent.com
GOOGLE_CLIENT_SECRET=tu-client-secret
GOOGLE_REDIRECT_URI=https://tu-app.onrender.com/oauth/google/callback

# Gmail
GMAIL_USER=tu-email@gmail.com
GMAIL_PASSWORD=tu-contraseña-de-aplicacion-16-chars

# Webhook (actualizar con tu URL real después del deploy)
WEBHOOK_URL=https://tu-app.onrender.com/webhook/form-obra
```

### 2.4 Deploy
- Haz clic en "Create Web Service"
- Espera 5-10 minutos para el build completo

---

## ⚙️ PASO 3: Configurar N8N

### 3.1 Acceder a N8N
1. Una vez desplegado, ve a: `https://tu-app.onrender.com/n8n`
2. Primera vez te pedirá configurar usuario (opcional con nuestro setup)

### 3.2 Importar Workflow
1. Ve a "Workflows" → "Import from file"
2. Selecciona: `n8n/workflows/informe_obra_n8n_workflow.json`
3. Importar

### 3.3 Configurar Credenciales en N8N
Ve a "Settings" → "Credentials" y agrega:

**OpenAI:**
- Tipo: "OpenAI"
- API Key: Tu key de OpenAI
- Nombre: "OpenAI ChatGPT"

**Google OAuth2:**
- Tipo: "Google OAuth2 API"
- Client ID: Tu Google Client ID
- Client Secret: Tu Google Client Secret
- Scope: `https://www.googleapis.com/auth/drive.file https://www.googleapis.com/auth/gmail.send`
- Nombre: "Google APIs"

**Gmail:**
- Tipo: "Gmail"
- Authentication: "OAuth2" o "App Password"
- Si usas App Password:
  - Email: tu-email@gmail.com
  - Password: contraseña-de-aplicacion

### 3.4 Activar Workflow
1. Abre tu workflow importado
2. Verifica que todos los nodos estén configurados
3. Haz clic en "Active" para activar el workflow

---

## 🧪 PASO 4: Probar el Sistema

### 4.1 Actualizar URL del Webhook
1. En Render, ve a tu servicio desplegado
2. Copia la URL real (ej: `https://informe-obra-ai-xyz.onrender.com`)
3. Actualiza la variable `WEBHOOK_URL` en Render
4. Redespliega si es necesario

### 4.2 Probar Formulario
1. Ve a tu app: `https://tu-app.onrender.com`
2. Llena el formulario
3. Graba un audio de prueba
4. Sube una foto
5. Envía el formulario

### 4.3 Verificar Flujo
1. Ve a N8N: `https://tu-app.onrender.com/n8n`
2. Ve a "Executions" para ver las ejecuciones
3. Verifica que el audio se transcribió
4. Confirma que se subió a Google Drive
5. Revisa que llegó el email

---

## 📊 FLUJO COMPLETO DEL SISTEMA

```
📱 Usuario llena formulario
    ↓
🎙️ Graba audio de observaciones
    ↓
📷 Sube fotos de la obra
    ↓
📤 Envía formulario
    ↓
🎯 Webhook recibe datos en N8N
    ↓
🤖 ChatGPT transcribe el audio
    ↓
📄 Se genera PDF con todos los datos
    ↓
☁️ PDF se sube a Google Drive
    ↓
📧 Gmail envía email con enlace al informe
    ↓
✅ Confirmación al usuario
```

---

## 💰 COSTOS ESTIMADOS

- **Render:** $0/mes (plan gratuito)
- **Google APIs:** $0/mes (límites generosos)
- **Gmail:** $0/mes (500 emails/día)
- **OpenAI:** $5-15/mes (según uso de transcripción)

**Total estimado:** $5-15/mes

---

## 🔧 TROUBLESHOOTING

### Error: OpenAI API
- Verifica que tengas créditos en tu cuenta
- Confirma que la API key sea válida
- Checa que el modelo `whisper-1` esté disponible

### Error: Google Drive/Gmail
- Confirma que las APIs estén habilitadas
- Verifica que el dominio esté autorizado en OAuth
- Revisa que los scopes sean correctos

### Error: Webhook no funciona
- Verifica que la URL del webhook sea correcta
- Confirma que el workflow esté activo
- Revisa los logs en Render

### Audio no se graba
- Confirma que tu app use HTTPS (automático en Render)
- Verifica permisos de micrófono en el navegador
- Prueba en diferentes navegadores

---

## 🎉 ¡SISTEMA LISTO!

Una vez configurado, tendrás un sistema profesional que:

✅ **Captura informes** con formulario web  
✅ **Transcribe audio** automáticamente con IA  
✅ **Almacena en Drive** todos los documentos  
✅ **Envía emails** automáticamente  
✅ **Escala** sin costos adicionales  
✅ **Funciona 24/7** en la nube  

**¡Tu sistema de informes de obra con IA está listo para usar! 🚀**
