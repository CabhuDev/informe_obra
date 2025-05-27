# 🚀 CONFIGURACIÓN DE VARIABLES EN RENDER

## PASO 1: Deploy en Render

1. Ve a: https://render.com/dashboard
2. Clic en "New +" → "Web Service"
3. Conecta GitHub: `CabhuDev/informe_obra`
4. Configuración:
   - **Name:** `informe-obra-ai` (o el nombre que prefieras)
   - **Environment:** Docker
   - **Plan:** Free
   - **Branch:** main

## PASO 2: Configurar Variables de Entorno

Una vez creado el servicio, ve a "Environment" y agrega estas variables:

### 📋 COPIA Y PEGA ESTAS VARIABLES

```bash
# N8N Core
NODE_ENV=production
N8N_HOST=0.0.0.0
N8N_PROTOCOL=http
N8N_USER_MANAGEMENT_DISABLED=true
N8N_ENCRYPTION_KEY=genera-una-clave-aleatoria-de-32-caracteres
DB_TYPE=sqlite
DB_SQLITE_DATABASE=/home/node/.n8n/database.sqlite
EXECUTIONS_DATA_PRUNE=true
EXECUTIONS_DATA_MAX_AGE=168

# Tu webhook URL (reemplaza 'tu-app-name' con el nombre real)
WEBHOOK_URL=https://tu-app-name.onrender.com/webhook/form-obra

# OpenAI (reemplaza con tu clave real)
OPENAI_API_KEY=sk-tu-clave-openai-aqui

# Google APIs (reemplaza con tus credenciales)
GOOGLE_CLIENT_ID=tu-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=tu-client-secret
GOOGLE_REDIRECT_URI=https://tu-app-name.onrender.com/oauth/callback

# Gmail (reemplaza con tus credenciales)
GMAIL_USER=tu-email@gmail.com
GMAIL_PASSWORD=tu-password-de-16-caracteres
```

## PASO 3: Actualizar URLs

**IMPORTANTE:** Una vez que tengas tu URL de Render (ej: `https://informe-obra-ai.onrender.com`), actualiza:

1. `WEBHOOK_URL=https://TU-APP-NAME.onrender.com/webhook/form-obra`
2. `GOOGLE_REDIRECT_URI=https://TU-APP-NAME.onrender.com/oauth/callback`

## PASO 4: Deploy

1. Clic en "Deploy Latest Commit"
2. Espera 5-10 minutos
3. Ve a tu URL: `https://tu-app-name.onrender.com`

## PASO 5: Configurar N8N

1. Ve a: `https://tu-app-name.onrender.com/n8n`
2. Importa workflow desde tu repositorio
3. Configura credenciales API
4. Activa el workflow

## ⚠️ IMPORTANTE

- **NUNCA** subas tu archivo `.env` a GitHub
- Las variables van SOLO en el dashboard de Render
- Tu `.env` local es solo para desarrollo/referencia

## 🆘 Si hay errores

Revisa los logs en Render dashboard → "Logs" para ver qué falla.

¡Tu sistema estará listo en 15 minutos! 🎉
