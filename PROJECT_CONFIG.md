# 🏗️ Sistema de Informes de Obra - Configuración Completa

## 📁 Estructura del Proyecto

```
informe_obra/
├── 🐳 DOCKER
│   ├── Dockerfile                 # Imagen base N8N + dependencias
│   ├── docker-entrypoint.sh       # Script de inicio multi-servicio
│   ├── .dockerignore              # Archivos excluidos del build
│   └── package.json               # Dependencias Node.js
├── ☁️ RENDER
│   ├── render.yaml                # Configuración de servicio
│   ├── DEPLOY.md                  # Guía rápida de despliegue
│   └── verify.sh                  # Script de verificación
├── 🌐 FRONTEND
│   └── public/
│       ├── index.html             # Formulario principal
│       ├── css/style.css          # Estilos CSS con variables
│       ├── js/
│       │   ├── script.js          # Lógica principal + auto-detección
│       │   └── audioRecord.js     # Grabación de audio
│       ├── templates/
│       │   ├── reportTemplate.html  # Template PDF elegante
│       │   └── reportSent.html      # Página de confirmación
│       └── assets/                # Favicons y manifesto
├── 🤖 BACKEND
│   └── n8n/
│       └── workflows/
│           └── informe_obra_n8n_workflow.json  # Workflow automatización
└── 📚 DOCS
    ├── README.md                  # Documentación completa
    ├── schema.txt                 # Esquema de datos
    └── .gitignore                 # Control de versiones
```

## ⚙️ Configuración Técnica

### Docker Multi-Servicio
- **Base:** N8N oficial con Node.js 18+
- **Servicios:** N8N + Express Proxy + Archivos Estáticos
- **Puerto:** Dinámico (Render PORT env var)
- **Persistencia:** SQLite embebido

### Funcionalidades Web
- **Formulario:** HTML5 + CSS Grid/Flexbox
- **Audio:** MediaRecorder API (requiere HTTPS)
- **Validación:** JavaScript nativo
- **Responsive:** Mobile-first design
- **Theme:** Construcción profesional

### Automatización N8N
- **Trigger:** Webhook POST `/webhook/informe-obra`
- **Procesamiento:** Datos → PDF → Email
- **Email:** Gmail SMTP con OAuth2
- **Template:** HTML to PDF con CSS print media
- **AI:** Integración OpenAI para análisis (opcional)

### Despliegue Render
- **Plan:** Free (750h/mes)
- **SSL:** Automático (HTTPS)
- **Dominio:** `*.onrender.com`
- **Build:** Docker automático
- **Variables:** Env vars por dashboard

## 🔑 Variables de Entorno Requeridas

### Obligatorias
```bash
GMAIL_USER=tu-email@gmail.com              # Email remitente
GMAIL_PASSWORD=contraseña-app-gmail        # Contraseña de aplicación
WEBHOOK_URL=https://tu-app.onrender.com/webhook/informe-obra
```

### Opcionales (con defaults)
```bash
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

## 🚀 Flujo de Despliegue

1. **Commit** → Git repository
2. **Connect** → Render + GitHub
3. **Configure** → Environment variables
4. **Deploy** → Automático (5-10 min)
5. **Setup** → Import workflow N8N
6. **Test** → Form submission + email

## 📊 URLs de Producción

- **App:** `https://tu-app.onrender.com`
- **N8N:** `https://tu-app.onrender.com/n8n`
- **Webhook:** `https://tu-app.onrender.com/webhook/informe-obra`
- **API Status:** `https://tu-app.onrender.com/webhook/health`

## 🔧 Comandos de Verificación

```bash
# Verificar despliegue
./verify.sh https://tu-app.onrender.com

# Test webhook local
curl -X POST http://localhost:5678/webhook/informe-obra \
  -H "Content-Type: application/json" \
  -d '{"projectName":"Test","date":"2025-05-27"}'

# Logs en Render
# Dashboard → Service → Logs (tiempo real)
```

## 🎯 Características Completadas

✅ **Frontend Responsive** - Form + audio + validation  
✅ **Docker Multi-Service** - N8N + Express + Static  
✅ **Auto Environment Detection** - Dev/Prod URLs  
✅ **Render Configuration** - render.yaml + env vars  
✅ **N8N Workflow** - Complete automation pipeline  
✅ **Email Integration** - Gmail SMTP ready  
✅ **PDF Generation** - Professional template  
✅ **Error Handling** - Graceful failures  
✅ **Documentation** - Complete guides  
✅ **Verification Scripts** - Automated testing  

## 📱 Compatibilidad

- **Browsers:** Chrome 60+, Firefox 55+, Safari 11+, Edge 79+
- **Mobile:** iOS 11+, Android 7+
- **Audio:** Requires HTTPS (auto en Render)
- **PDF:** All modern browsers
- **Email:** Gmail, Outlook, Apple Mail

## 🔒 Seguridad

- **HTTPS:** Forzado por Render
- **Headers:** CORS configurado
- **Credentials:** Environment variables
- **Data:** No persistencia local de datos sensibles
- **Audio:** Procesado client-side, no almacenado

## 💰 Costos

- **Render Free:** $0/mes (750 horas)
- **Gmail:** Gratuito (limitado a 500 emails/día)
- **Domain:** `*.onrender.com` incluido
- **SSL:** Incluido
- **N8N:** Incluido (comunidad)

## 🎉 ¡Proyecto Listo para Producción!

El sistema está completamente configurado y listo para desplegarse en Render. Todos los archivos están optimizados, la documentación es completa y el flujo de trabajo está automatizado.
