# 🚀 Guía Completa de Despliegue en Render

## ✅ Estado Actual del Proyecto
- ✅ Frontend listo y funcionando
- ✅ N8N workflow configurado  
- ✅ Dockerfile optimizado
- ✅ Scripts de inicio configurados
- ✅ Variables de entorno documentadas

## 📋 Pasos para Despliegue

### 1. Preparar Repositorio Git
```bash
# Añadir todos los archivos
git add .

# Commit con mensaje descriptivo
git commit -m "Sistema de informes completo - listo para Render"

# Subir a GitHub
git push origin main
```

### 2. Crear Servicio en Render

1. **Ir a [dashboard.render.com](https://dashboard.render.com)**
2. **Clic en "New" → "Web Service"**
3. **Conectar repositorio de GitHub**
4. **Configuración del servicio:**
   - **Name:** `informe-obra-ai`
   - **Environment:** `Docker`
   - **Plan:** `Free`
   - **Auto-Deploy:** `Yes` ✅

### 3. Variables de Entorno OBLIGATORIAS

En la sección "Environment" de Render, añadir:

```env
# OpenAI (OBLIGATORIO)
OPENAI_API_KEY=sk-tu-api-key-aqui

# Gmail (OBLIGATORIO) 
GMAIL_USER=tu-email@gmail.com
GMAIL_PASSWORD=tu-contraseña-app-gmail

# Webhook URL (OBLIGATORIO)
WEBHOOK_URL=https://informe-obra-ai.onrender.com/webhook/form-obra
```

### 4. Obtener Contraseña de Aplicación Gmail

1. **Ir a [myaccount.google.com](https://myaccount.google.com)**
2. **Seguridad → Verificación en 2 pasos** (activar si no está)
3. **Contraseñas de aplicaciones**
4. **Generar nueva contraseña para "Sistema de informes"**
5. **Usar esa contraseña en `GMAIL_PASSWORD`**

## 🌐 URLs Finales

Una vez desplegado tendrás:

- **🏠 Frontend:** `https://informe-obra-ai.onrender.com`
- **⚙️ N8N Editor:** `https://informe-obra-ai.onrender.com:5678`
- **🔗 Webhook:** `https://informe-obra-ai.onrender.com/webhook/form-obra`
- **💾 Health Check:** `https://informe-obra-ai.onrender.com/health`

## ⚡ Ventajas vs ngrok

| Característica | Render | ngrok |
|---|---|---|
| **Costo** | 🟢 Gratis 750h/mes | 🔴 Limitado/Pago |
| **URLs** | 🟢 Permanentes | 🔴 Cambian cada vez |
| **HTTPS** | 🟢 Automático | 🔴 Configuración manual |
| **Estabilidad** | 🟢 Producción | 🔴 Solo desarrollo |
| **Escalabilidad** | 🟢 Automática | 🔴 Manual |

## 🎯 Proceso de Build en Render

1. **Build del contenedor** (~5-8 minutos)
2. **Inicio de N8N** (~30 segundos)
3. **Inicio del frontend** (~10 segundos)
4. **Sistema listo** ✅

## 📞 Soporte Post-Despliegue

- **Logs en tiempo real:** Disponibles en dashboard de Render
- **Reinicio automático:** Si algo falla, Render reinicia
- **Monitoreo:** Health checks automáticos cada 30s
- **Updates:** Auto-deploy cuando hagas push a GitHub

## 🔧 Troubleshooting

### Si N8N no se conecta:
1. Verificar `WEBHOOK_URL` en variables de entorno
2. Comprobar que el workflow está importado
3. Revisar logs en Render dashboard

### Si no llegan emails:
1. Verificar `GMAIL_USER` y `GMAIL_PASSWORD`
2. Confirmar que la contraseña de app Gmail es correcta
3. Comprobar bandeja de spam

### Si OpenAI falla:
1. Verificar `OPENAI_API_KEY` es válida
2. Comprobar saldo en cuenta OpenAI
3. Verificar límites de API

¡Tu sistema estará disponible 24/7 con HTTPS automático! 🎉
