# Sistema de Informes de Obra con N8N y IA

Sistema completo de captura y procesamiento de informes de construcción con:
- 📱 Frontend web para captura de datos y audio
- 🤖 N8N para automatización de workflows  
- 🧠 OpenAI para transcripción y análisis con IA
- 📧 Envío automático de informes por email
- ☁️ Despliegue gratuito en Render con HTTPS

## 🚀 Despliegue en Render (100% Gratis)

### ¿Por qué Render y no ngrok?

| Característica | Render (✅ Recomendado) | Ngrok (❌ Solo desarrollo) |
|---|---|---|
| **URLs** | Permanentes con HTTPS | Temporales, cambian cada reinicio |
| **Costo** | Gratis (750h/mes) | Limitado gratis, requiere pago |
| **Estabilidad** | Producción real | Solo para testing |
| **SSL/HTTPS** | Automático | Requiere configuración |
| **Escalabilidad** | Automática | Manual |

### Prerrequisitos

1. Cuenta en [Render.com](https://render.com) (gratis)
2. Repositorio de GitHub con el código
3. API Key de OpenAI
4. Cuenta de Gmail con contraseña de aplicación

### Paso 1: Verificar Archivos

Ejecuta el script de verificación:

### Paso 2: Crear el Servicio en Render

1. Ve a [Render Dashboard](https://dashboard.render.com)
2. Haz clic en "New +" → "Web Service"
3. Conecta tu repositorio de GitHub
4. Selecciona el repositorio del proyecto

### Paso 3: Configurar el Servicio

En la página de configuración:

**Build & Deploy:**
- **Environment:** Docker
- **Dockerfile Path:** `./Dockerfile`
- **Build Command:** (dejar vacío)
- **Start Command:** (dejar vacío)

**Plan:**
- Selecciona "Free" (0$/mes)

### Paso 4: Variables de Entorno

Configura las siguientes variables de entorno en la sección "Environment":

#### Variables Obligatorias:
```
GMAIL_USER=tu-email@gmail.com
GMAIL_PASSWORD=tu-contraseña-de-aplicacion
WEBHOOK_URL=https://tu-app.onrender.com/webhook/informe-obra
```

#### Variables Opcionales (ya configuradas por defecto):
```
NODE_ENV=production
N8N_HOST=0.0.0.0
N8N_PROTOCOL=http
N8N_USER_MANAGEMENT_DISABLED=true
N8N_DIAGNOSTICS_ENABLED=false
N8N_VERSION_NOTIFICATIONS_ENABLED=false
N8N_TEMPLATES_ENABLED=false
N8N_ONBOARDING_FLOW_DISABLED=true
EXECUTIONS_DATA_PRUNE=true
EXECUTIONS_DATA_MAX_AGE=168
```

### Paso 5: Configurar Gmail

Para usar Gmail como servidor SMTP:

1. Ve a tu cuenta de Google
2. Activa la autenticación de 2 factores
3. Genera una "Contraseña de aplicación":
   - Ve a "Gestionar tu cuenta de Google"
   - Seguridad → Verificación en 2 pasos → Contraseñas de aplicaciones
   - Selecciona "Correo" y "Otro" → "N8N App"
   - Copia la contraseña generada (16 caracteres)
4. Usa esta contraseña en la variable `GMAIL_PASSWORD`

### Paso 6: Desplegar

1. Haz clic en "Create Web Service"
2. Render comenzará a construir y desplegar tu aplicación
3. El proceso toma entre 5-10 minutos

### Paso 7: Verificar el Despliegue

1. Una vez desplegado, obtendrás una URL como `https://tu-app.onrender.com`
2. Visita la URL para ver el formulario de informes
3. Accede a la interfaz de N8N en `https://tu-app.onrender.com/n8n/`

### Paso 8: Configurar N8N

1. Accede a `https://tu-app.onrender.com/n8n/`
2. Importa el workflow desde `n8n/workflow.json`
3. Configura las credenciales de Gmail en N8N:
   - Ve a "Settings" → "Credentials"
   - Crea nueva credencial "Gmail OAuth2 API"
   - Usa tus datos de Gmail

### Paso 9: Actualizar la URL del Webhook

1. En Render, ve a "Environment"
2. Actualiza `WEBHOOK_URL` con tu URL real:
   ```
   WEBHOOK_URL=https://tu-app-real.onrender.com/webhook/informe-obra
   ```
3. Redespliega la aplicación

## 🔧 Funcionalidades

### Formulario Web
- Captura de datos del informe de obra
- Grabación de audio (funciona en HTTPS)
- Subida de fotos
- Validación de datos

### Automatización N8N
- Procesamiento automático de datos
- Generación de PDF con template personalizado
- Envío de emails con adjuntos
- Integración con IA para análisis

### Características Técnicas
- Docker multi-servicio (N8N + Nginx)
- Base de datos SQLite embebida
- Auto-detección de entorno (desarrollo/producción)
- Optimizado para el plan gratuito de Render

## 🐛 Solución de Problemas

### La aplicación no arranca
- Verifica que todas las variables de entorno estén configuradas
- Revisa los logs en Render Dashboard

### El webhook no funciona
- Asegúrate de que `WEBHOOK_URL` apunte a tu dominio real de Render
- Verifica que el workflow esté activo en N8N

### Los emails no se envían
- Confirma que uses una contraseña de aplicación de Gmail
- Verifica las credenciales en N8N

### La grabación de audio no funciona
- La grabación requiere HTTPS (automático en Render)
- Permite permisos de micrófono en el navegador

## 📝 Notas Importantes

- **Plan Gratuito:** 750 horas/mes, aplicación se suspende tras 15 min de inactividad
- **Persistencia:** Los datos de N8N se mantienen entre reinicios
- **HTTPS:** Automático en Render, necesario para grabación de audio
- **Actualizaciones:** Push a main/master redespliega automáticamente

## 🔗 URLs Importantes

- **Aplicación Principal:** `https://tu-app.onrender.com`
- **Interfaz N8N:** `https://tu-app.onrender.com/n8n/`
- **Webhook:** `https://tu-app.onrender.com/webhook/informe-obra`

## 📞 Soporte

Para problemas con el despliegue:
1. Revisa los logs en Render Dashboard
2. Verifica las variables de entorno
3. Comprueba que el repositorio tenga todos los archivos
4. Asegúrate de que Gmail esté configurado correctamente
