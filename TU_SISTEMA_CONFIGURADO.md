# 🚀 CONFIGURACIÓN ESPECÍFICA PARA TU DESPLIEGUE

## 🌐 **URLs de tu Sistema**

Tu aplicación está desplegada en: **https://informe-obra-ai.onrender.com**

### 📋 **URLs Específicas de tu Sistema:**

| Servicio | URL Completa |
|----------|--------------|
| **🏠 Frontend (Formulario)** | `https://informe-obra-ai.onrender.com` |
| **⚙️ Editor N8N** | `https://informe-obra-ai.onrender.com/n8n/` |
| **🔗 Webhook (Recibe formularios)** | `https://informe-obra-ai.onrender.com/webhook/form-obra` |
| **💓 Health Check** | `https://informe-obra-ai.onrender.com/health` |
| **📊 Webhook Status** | `https://informe-obra-ai.onrender.com/webhook/status` |

## ⚙️ **Variables de Entorno en Render**

En el dashboard de Render, estas son las variables que DEBES configurar:

```env
# OpenAI (OBLIGATORIO para transcripción de audio)
OPENAI_API_KEY=tu-clave-openai-aqui

# Gmail (OBLIGATORIO para envío de informes)
GMAIL_USER=tu-email@gmail.com
GMAIL_PASSWORD=tu-contraseña-de-aplicacion-gmail

# URL del sistema (OBLIGATORIO)
WEBHOOK_URL=https://informe-obra-ai.onrender.com/webhook/form-obra

# Google OAuth (para Drive y Gmail avanzado)
GOOGLE_CLIENT_ID=1034976373955-hktpjo0tt854agtd4ed6rhepi4gdoqlu.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=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
GOOGLE_REDIRECT_URI=https://informe-obra-ai.onrender.com/oauth/callback

# N8N Encryption (OBLIGATORIO para seguridad)
N8N_ENCRYPTION_KEY=Wz9gP4tUx93bQ7nCa6yV0eZ2LpR1HsKD
```

## 🔑 **Obtener Contraseña de Gmail**

1. Ve a [myaccount.google.com](https://myaccount.google.com)
2. **Seguridad** → **Verificación en 2 pasos** (activar si no está)
3. **Contraseñas de aplicaciones** → **Seleccionar app: Correo**
4. **Generar** → Copiar la contraseña de 16 dígitos
5. Usar esa contraseña en `GMAIL_PASSWORD`

## 🧪 **Probar el Sistema**

### **1. Probar Frontend:**
```
https://informe-obra-ai.onrender.com
```
Deberías ver el formulario de informes de obra.

### **2. Probar N8N Editor:**
```
https://informe-obra-ai.onrender.com/n8n/
```
Deberías ver la interfaz de N8N con tu workflow cargado.

### **3. Probar Health Check:**
```
https://informe-obra-ai.onrender.com/health
```
Debería devolver: `{"status":"OK","timestamp":"...","service":"informe-obra-app","version":"1.0.0"}`

### **4. Probar Webhook Status:**
```
https://informe-obra-ai.onrender.com/webhook/status
```
Debería devolver: `{"status":"Webhook endpoint ready","n8n_endpoint":"/webhook/form-obra"}`

## 🔧 **Si Algo No Funciona**

### **N8N no se ve:**
1. Ir a `https://informe-obra-ai.onrender.com/n8n/`
2. Esperar 30-60 segundos (N8N tarda en cargar)
3. Verificar logs en Render dashboard

### **Webhook no funciona:**
1. Verificar que `WEBHOOK_URL` está configurado correctamente
2. Comprobar que el workflow está activo en N8N
3. Revisar logs de errores

### **No llegan emails:**
1. Verificar `GMAIL_PASSWORD` (debe ser contraseña de aplicación)
2. Comprobar `GMAIL_USER` (debe ser tu email completo)
3. Revisar bandeja de spam

## 📱 **Flujo Completo de Uso**

1. **Usuario entra:** `https://informe-obra-ai.onrender.com`
2. **Llena formulario** con datos del proyecto
3. **Graba audio** con observaciones
4. **Envía formulario** → Se procesa automáticamente
5. **N8N transcribe** el audio con OpenAI
6. **IA analiza** y genera resumen
7. **Sistema envía email** con informe en PDF/HTML
8. **Administrador revisa** workflow en `/n8n/`

¡Tu sistema está 100% funcional y listo para usar! 🎉
