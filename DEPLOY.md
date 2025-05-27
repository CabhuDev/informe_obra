# ⚡ Guía Rápida de Despliegue en Render

## 🚀 Pasos Rápidos (5 minutos)

### 1. Subir a GitHub
```bash
git init
git add .
git commit -m "Sistema de informes de obra para Render"
git branch -M main
git remote add origin https://github.com/tu-usuario/informe-obra.git
git push -u origin main
```

### 2. Crear Servicio en Render
1. Ve a [Render.com](https://render.com) → "New" → "Web Service"
2. Conecta tu repositorio
3. Configuración:
   - **Name:** `informe-obra-app`
   - **Environment:** Docker
   - **Plan:** Free

### 3. Variables de Entorno Esenciales
```
GMAIL_USER=tu-email@gmail.com
GMAIL_PASSWORD=tu-contraseña-de-app-gmail
WEBHOOK_URL=https://tu-app.onrender.com/webhook/informe-obra
```

### 4. Configurar Gmail
1. Google Account → Seguridad → 2FA (activar)
2. Contraseñas de aplicaciones → Generar para "N8N"
3. Usar esa contraseña en `GMAIL_PASSWORD`

### 5. Deploy
- Haz clic en "Create Web Service"
- Espera 5-10 minutos

### 6. Verificar
- Tu app estará en: `https://tu-app.onrender.com`
- Panel N8N: `https://tu-app.onrender.com/n8n`

## 🔧 URLs Finales
- **Formulario:** `https://tu-app.onrender.com/`
- **N8N Dashboard:** `https://tu-app.onrender.com/n8n/`
- **Webhook:** `https://tu-app.onrender.com/webhook/informe-obra`

## ⚠️ Troubleshooting Rápido

### App no arranca
- Verifica variables de entorno
- Revisa logs en Render Dashboard

### Webhook no funciona  
- Actualiza `WEBHOOK_URL` con tu dominio real
- Activa el workflow en N8N

### Emails no se envían
- Usa contraseña de aplicación Gmail (no tu contraseña normal)
- Verifica credenciales en N8N

## 🎯 Próximos Pasos
1. Importar workflow en N8N (`/n8n/workflows/informe_obra_n8n_workflow.json`)
2. Configurar credenciales Gmail en N8N
3. Activar el workflow
4. Probar envío de formulario

¡Listo! Tu sistema de informes de obra está desplegado y funcionando. 🎉
