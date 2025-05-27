# 🔧 Cómo Funciona el Acceso a N8N en Render

## ❌ **ERROR COMÚN: Puertos Específicos**

**INCORRECTO:**
```
https://tu-app.onrender.com:5678  ❌
```

**MOTIVO:** Render solo expone UN puerto por servicio (asignado dinámicamente).

## ✅ **SOLUCIÓN: Proxy Reverso**

**CORRECTO:**
```
https://tu-app.onrender.com/n8n/  ✅
```

## 🔄 **Cómo Funciona Internamente**

```
Usuario → https://tu-app.onrender.com/n8n/
    ↓
Render (Puerto dinámico, ej: 10000)
    ↓  
Express Server (server.js)
    ↓
Proxy Middleware
    ↓
N8N (Puerto interno 5678)
```

## 📋 **Configuración del Proxy**

En `server.js` he agregado:

```javascript
// Proxy para acceder al editor N8N
app.use('/n8n', createProxyMiddleware({
  target: 'http://localhost:5678',
  changeOrigin: true,
  pathRewrite: { '^/n8n': '' }
}));

// Proxy para webhooks
app.use('/webhook', createProxyMiddleware({
  target: 'http://localhost:5678',
  changeOrigin: true,
  pathRewrite: { '^/webhook': '/webhook' }
}));
```

## 🌐 **URLs Finales Correctas**

| Servicio | URL Pública |
|----------|-------------|
| **Frontend** | `https://tu-app.onrender.com` |
| **N8N Editor** | `https://tu-app.onrender.com/n8n/` |
| **Webhooks** | `https://tu-app.onrender.com/webhook/form-obra` |
| **Health Check** | `https://tu-app.onrender.com/health` |

## 🔐 **Variables de Entorno Actualizadas**

```env
# URL correcta para webhooks
WEBHOOK_URL=https://tu-app.onrender.com/webhook/form-obra

# N8N sigue usando puerto interno
N8N_PORT=5678
N8N_HOST=0.0.0.0
```

## ⚡ **Ventajas del Proxy Reverso**

1. **✅ Un solo certificado SSL** para todo
2. **✅ Un solo dominio** fácil de recordar  
3. **✅ CORS automático** resuelto
4. **✅ Logs centralizados** en Express
5. **✅ Manejo de errores** personalizado

## 🚀 **Flujo Completo de Trabajo**

1. **Usuario accede** → `https://tu-app.onrender.com`
2. **Llena formulario** → Envía a webhook
3. **Webhook procesa** → `https://tu-app.onrender.com/webhook/form-obra`
4. **N8N ejecuta workflow** → Internamente en puerto 5678
5. **Administrador accede N8N** → `https://tu-app.onrender.com/n8n/`

¡Ahora las URLs son correctas y funcionarán perfectamente en Render! 🎯
