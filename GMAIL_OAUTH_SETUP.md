# 🔧 CONFIGURACIÓN GMAIL OAUTH2 - PASO A PASO

## ✅ VENTAJAS DE OAUTH2 vs CONTRASEÑA
- ✅ **Más seguro** (no expones tu contraseña)
- ✅ **Recomendado por Google** y N8N
- ✅ **Mismas credenciales** que Google Drive
- ✅ **Fácil revocación** de acceso si necesario

## 🔑 VERIFICAR GOOGLE CLOUD CONSOLE

### PASO 1: Verificar APIs habilitadas
1. Ve a: https://console.cloud.google.com/apis/dashboard
2. Asegúrate que estén habilitadas:
   - ✅ **Google Drive API**
   - ✅ **Gmail API** ← **¡IMPORTANTE!**

### PASO 2: Verificar Scopes en OAuth
1. Ve a: https://console.cloud.google.com/apis/credentials
2. Edita tu credencial OAuth2
3. En "Scopes", asegúrate que incluya:
   ```
   https://www.googleapis.com/auth/drive
   https://www.googleapis.com/auth/gmail.send
   https://www.googleapis.com/auth/gmail.compose
   ```

### PASO 3: URLs Autorizadas
En tu credencial OAuth2, agrega estas URLs:
```
Orígenes autorizados:
- https://tu-app-name.onrender.com
- http://localhost:5678 (para desarrollo)

URIs de redirección:
- https://tu-app-name.onrender.com/rest/oauth2-credential/callback
- http://localhost:5678/rest/oauth2-credential/callback
```

## 🚀 CONFIGURACIÓN EN N8N

### PASO 1: Crear Credencial Gmail OAuth2
1. Ve a N8N → Settings → Credentials
2. "Add Credential" → "Gmail OAuth2 API"
3. Configurar:
   ```
   Client ID: 1034976373955-hktpjo0tt854agtd4ed6rhepi4gdoqlu.apps.googleusercontent.com
   Client Secret: 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
   ```
4. Clic en "Connect my account"
5. Autorizar en Google

### PASO 2: Usar en tu Workflow
- En el nodo Gmail, selecciona tu credencial OAuth2
- N8N manejará automáticamente el refresh token

## 📋 VARIABLES FINALES PARA RENDER

```bash
# Google APIs (mismo proyecto para Drive y Gmail)
GOOGLE_CLIENT_ID=1034976373955-hktpjo0tt854agtd4ed6rhepi4gdoqlu.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=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

# Gmail OAuth2 (mismas credenciales)
GMAIL_CLIENT_ID=1034976373955-hktpjo0tt854agtd4ed6rhepi4gdoqlu.apps.googleusercontent.com
GMAIL_CLIENT_SECRET=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
GMAIL_USER=pablo.cabello.hurtafo@gmail.com
```

## ⚠️ IMPORTANTE

- **NO uses tu contraseña real** de Gmail en aplicaciones
- **OAuth2 es más seguro** y es el estándar
- **Un solo proyecto** de Google Cloud para Drive + Gmail
- **N8N maneja automáticamente** los tokens

## 🔍 SI HAY PROBLEMAS

1. **Error de permisos:** Verifica que Gmail API esté habilitada
2. **Error de OAuth:** Revisa las URLs de redirección
3. **Error de scopes:** Asegúrate que incluya gmail.send

¡Tu configuración será mucho más segura y profesional! 🔒
