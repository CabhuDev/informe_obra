# 📋 Sistema de Informes de Obra - Obratec.app

Sistema automatizado para generar informes semanales de obra con integración de IA, transcripción de audio y envío automático por email.

[![Deploy Status](https://img.shields.io/badge/deploy-ready-green.svg)](https://obratec.app)
[![Docker](https://img.shields.io/badge/docker-ready-blue.svg)](./docker-compose.vps.yml)
[![Security](https://img.shields.io/badge/security-hardened-red.svg)](./n8n/security.json)

## ✨ Características

- **📱 Formulario web responsive** - Compatible con móviles y tablets
- **🎙️ Grabación de audio** - Observaciones de voz con transcripción automática
- **🤖 IA integrada** - Generación automática de resúmenes con OpenAI
- **📧 Envío automático** - Email con PDF adjunto usando Gmail OAuth2
- **🔒 Seguridad avanzada** - N8N completamente protegido y no accesible
- **🐳 Docker ready** - Despliegue fácil con Docker Compose
- **⚡ Alta disponibilidad** - Configurado para VPS de producción

## 🛠️ Arquitectura del Sistema

```
Frontend (Puerto 3000) → N8N Webhook → OpenAI API → Gmail API
      ↓                      ↓             ↓           ↓
   Nginx Proxy          Procesamiento  Transcripción  Email
  (obratec.app)         Workflows      y Análisis    Automático
```

## 🚀 Despliegue Rápido

### Opción 1: Despliegue en VPS (Recomendado)

```bash
# 1. Clona el repositorio
git clone https://github.com/tu-usuario/informe_obra.git
cd informe_obra

# 2. Configura variables de entorno
cp .env.example .env
# Edita .env con tus claves API

# 3. Ejecuta el script de despliegue
chmod +x deploy-vps.sh
./deploy-vps.sh
```

### Opción 2: Docker Compose Local

```bash
# 1. Clona y configura
git clone https://github.com/tu-usuario/informe_obra.git
cd informe_obra
cp .env.example .env

# 2. Ejecuta con Docker
docker-compose -f docker-compose.vps.yml up -d

# 3. Accede a:
# - Aplicación: http://localhost:3000
# - Webhook: http://localhost:3000/webhook/form-obra
```

## 📋 Configuración Requerida

### 1. Variables de Entorno (.env)

```env
# Configuración básica
NODE_ENV=production
N8N_HOST=tu-dominio.com
N8N_PROTOCOL=https
WEBHOOK_URL=https://tu-dominio.com/webhook/form-obra

# Seguridad N8N
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=tu_password_seguro
N8N_ENCRYPTION_KEY=clave_32_caracteres_aleatoria

# APIs necesarias
OPENAI_API_KEY=sk-proj-tu_clave_openai
GOOGLE_CLIENT_ID=tu_google_client_id
GOOGLE_CLIENT_SECRET=tu_google_client_secret
GMAIL_USER=tu_email@gmail.com
GMAIL_PASSWORD=tu_app_password
```

### 2. Configuración de Google APIs

1. **Google Cloud Console**:
   - Crear proyecto nuevo
   - Habilitar Gmail API
   - Crear credenciales OAuth 2.0
   - Configurar pantalla de consentimiento

2. **OpenAI API**:
   - Crear cuenta en OpenAI
   - Generar API key
   - Configurar límites de uso

## 📁 Estructura del Proyecto

```
informe_obra/
├── 📄 public/                 # Frontend
│   ├── index.html            # Formulario principal
│   ├── js/script.js          # Lógica del formulario
│   └── css/style.css         # Estilos
├── 🔧 n8n/                   # Workflows N8N
│   ├── workflows/
│   │   └── informe_obra_n8n_workflow.json
│   └── security.json         # Configuración de seguridad
├── 🐳 Docker/
│   ├── docker-compose.vps.yml
│   └── Dockerfile
├── 🛡️ Seguridad/
│   ├── security-monitor.sh   # Monitor de seguridad
│   └── server.js            # Proxy seguro
└── 📚 Documentación/
    ├── DEPLOY_GUIDE.md
    └── README.md
```

## 🔐 Características de Seguridad

### N8N Completamente Protegido

- ✅ **Puerto 5678 no expuesto** - Solo comunicación interna
- ✅ **UI bloqueada** - Imposible acceder a la interfaz administrativa
- ✅ **Autenticación obligatoria** - Usuario y contraseña para acceso
- ✅ **Funciones peligrosas deshabilitadas** - No ejecución de comandos del sistema
- ✅ **Solo webhooks permitidos** - Endpoints REST bloqueados

### Proxy de Seguridad

```javascript
// Middleware que bloquea acceso a rutas administrativas
const blockedPaths = ['/n8n/', '/editor/', '/workflows/', '/credentials/'];
// Solo permite /webhook/ para el funcionamiento de la app
```

## 🚦 Verificación del Sistema

### Script de Monitoreo

```bash
# Ejecutar verificación completa
./security-monitor.sh

# Salida esperada:
# ✅ Puerto 5678 seguro (no expuesto públicamente)
# ✅ Autenticación básica activada
# ✅ Funciones peligrosas bloqueadas
# ✅ UI administrativa bloqueada
```

### Prueba Manual

```bash
# Probar webhook (debe funcionar)
curl -X POST http://localhost:3000/webhook/form-obra \
  -H "Content-Type: application/json" \
  -d '{"test": "true"}'

# Probar acceso a UI (debe estar bloqueado)
curl http://localhost:3000/n8n/
# Respuesta esperada: 403 Forbidden
```

## 📧 Workflow del Sistema

1. **Usuario completa formulario** → Datos + audio
2. **Webhook recibe datos** → Activa workflow N8N
3. **N8N procesa información**:
   - Transcribe audio con OpenAI
   - Genera resumen inteligente
   - Crea HTML formateado
   - Convierte a PDF
4. **Envía email automático** → Gmail con PDF adjunto

## 🔄 Mantenimiento

### Actualizaciones

```bash
# Actualizar código
git pull origin main

# Reconstruir contenedores
docker-compose -f docker-compose.vps.yml down
docker-compose -f docker-compose.vps.yml up --build -d
```

### Logs y Debugging

```bash
# Ver logs de la aplicación
docker logs -f obratec-app

# Ver logs de N8N
docker logs -f obratec-n8n

# Verificar estado de contenedores
docker ps
```

### Backup

```bash
# Backup de workflows N8N
docker exec obratec-n8n cp -r /home/node/.n8n/workflows /backup/

# Backup de base de datos SQLite
docker exec obratec-n8n cp /home/node/.n8n/database.sqlite /backup/
```

## 🐛 Solución de Problemas

### Problemas Comunes

| Problema | Solución |
|----------|----------|
| CORS Error | Verificar que ambos servicios usen el mismo hostname |
| Audio no se envía | Comprobar que el input type="file" esté configurado |
| Email no llega | Verificar credenciales Gmail y app password |
| N8N no responde | Verificar que el contenedor esté corriendo |

### Comandos de Diagnóstico

```bash
# Verificar puertos
netstat -tlnp | grep :3000
netstat -tlnp | grep :5678

# Verificar DNS
nslookup tu-dominio.com

# Verificar SSL
openssl s_client -connect tu-dominio.com:443
```

## 📊 Métricas y Monitoreo

### Archivos de Log

- `/var/log/nginx/access.log` - Accesos web
- `docker logs obratec-app` - Aplicación principal
- `docker logs obratec-n8n` - Workflows N8N

### Alertas Automáticas

El sistema registra y alerta sobre:
- Intentos de acceso a rutas bloqueadas
- Errores en el procesamiento de formularios
- Fallos en el envío de emails
- Problemas de conectividad con APIs

## 🤝 Contribuir

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 📞 Soporte

- 📧 Email: soporte@obratec.app
- 📚 Documentación: [Wiki del proyecto](https://github.com/tu-usuario/informe_obra/wiki)
- 🐛 Issues: [GitHub Issues](https://github.com/tu-usuario/informe_obra/issues)

---

**🔗 Enlaces Útiles:**
- [Documentación N8N](https://docs.n8n.io/)
- [API OpenAI](https://platform.openai.com/docs/)
- [Gmail API](https://developers.google.com/gmail/api)
- [Docker Compose](https://docs.docker.com/compose/)

> **⚠️ Nota**: Este sistema está diseñado para ser completamente seguro. N8N no es accesible desde internet y solo funciona como motor de automatización interno.

```
Frontend (Puerto 3000) → N8N Webhooks (Puerto 5678) → OpenAI API → Gmail API
      ↓                           ↓                        ↓           ↓
   Nginx Proxy              Procesamiento             Transcripción  Email
  (obratec.app)              Workflows                 y Análisis    Automático
```

## 🚀 Despliegue en VPS

### Prerequisitos

- VPS con Ubuntu/Debian
- Docker y Docker Compose instalados
- Dominio configurado (obratec.app)
- Acceso SSH al servidor

### 1. Clonación del Repositorio

```bash
git clone https://github.com/tu-usuario/informe_obra.git
cd informe_obra
```

### 2. Configuración de Variables de Entorno

```bash
# Copiar archivo de ejemplo
cp .env.vps.example .env

# Editar variables de entorno
nano .env
```

Variables requeridas:
```env
# URLs de la aplicación
FRONTEND_URL=https://obratec.app
N8N_URL=https://n8n.obratec.app
WEBHOOK_URL=https://obratec.app/webhook/form-obra

# Configuración N8N
N8N_HOST=n8n.obratec.app
N8N_PROTOCOL=https
N8N_PORT=443

# APIs
OPENAI_API_KEY=tu_clave_openai
GMAIL_CLIENT_ID=tu_client_id_gmail
GMAIL_CLIENT_SECRET=tu_client_secret_gmail
GMAIL_REFRESH_TOKEN=tu_refresh_token_gmail

# Email configuración
FROM_EMAIL=sistema@obratec.app
TO_EMAIL=informes@empresa.com
```

### 3. Despliegue Automático

```bash
# Dar permisos de ejecución
chmod +x deploy-vps.sh

# Ejecutar script de despliegue
./deploy-vps.sh
```

### 4. Configuración de Nginx

```bash
# Copiar configuración de Nginx
sudo cp nginx.conf.example /etc/nginx/sites-available/obratec
sudo ln -s /etc/nginx/sites-available/obratec /etc/nginx/sites-enabled/

# Obtener certificados SSL
sudo certbot --nginx -d obratec.app -d n8n.obratec.app

# Reiniciar Nginx
sudo systemctl restart nginx
```

## 📋 Configuración Post-Despliegue

### 1. Importar Workflows N8N

1. Acceder a https://n8n.obratec.app
2. Ir a `Workflows` → `Import from File`
3. Cargar `n8n/workflows/informe_obra_n8n_workflow.json`
4. Activar el workflow

### 2. Verificar Sistema

```bash
# Ejecutar script de verificación (Windows PowerShell)
./final-setup.ps1

# O verificar manualmente
curl -X POST https://obratec.app/webhook/form-obra \
  -H "Content-Type: application/json" \
  -d '{"test": "true"}'
```

## 📁 Estructura del Proyecto

```
informe_obra/
├── public/                     # Frontend web
│   ├── index.html             # Formulario principal
│   ├── styles.css             # Estilos
│   └── script.js              # JavaScript cliente
├── n8n/
│   └── workflows/             # Workflows N8N
│       └── informe_obra_n8n_workflow.json
├── docker-compose.vps.yml     # Configuración Docker VPS
├── deploy-vps.sh              # Script de despliegue
├── nginx.conf.example         # Configuración Nginx
├── server.js                  # Servidor Node.js
├── Dockerfile                 # Imagen Docker
└── .env.vps.example          # Variables de entorno template
```

## 🔧 Desarrollo Local

### Instalación

```bash
# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus claves

# Ejecutar en desarrollo
npm start
```

### Docker Local

```bash
# Construir y ejecutar
docker-compose up --build

# Acceder a:
# - Frontend: http://localhost:3000
# - N8N: http://localhost:5678
```

## 🐛 Solución de Problemas

### Verificar Estado de Contenedores

```bash
docker ps
docker logs obratec-app
docker logs obratec-n8n
```

### Verificar Nginx

```bash
sudo nginx -t
sudo systemctl status nginx
sudo journalctl -u nginx -f
```

### Verificar SSL

```bash
sudo certbot certificates
sudo certbot renew --dry-run
```

### Logs de la Aplicación

```bash
# Ver logs en tiempo real
docker logs -f obratec-app
docker logs -f obratec-n8n

# Ver logs específicos
docker exec -it obratec-app cat /var/log/app.log
```

## 📧 Configuración de Email

### Gmail OAuth Setup

1. Crear proyecto en Google Cloud Console
2. Habilitar Gmail API
3. Crear credenciales OAuth 2.0
4. Obtener refresh token usando:

```bash
# Usar herramienta OAuth Playground o script personalizado
curl -X POST https://oauth2.googleapis.com/token \
  -d "client_id=TU_CLIENT_ID" \
  -d "client_secret=TU_CLIENT_SECRET" \
  -d "refresh_token=TU_REFRESH_TOKEN" \
  -d "grant_type=refresh_token"
```

## 🔐 Seguridad

- ✅ HTTPS con certificados Let's Encrypt
- ✅ Variables de entorno para credenciales
- ✅ Network isolation en Docker
- ✅ Reverse proxy con Nginx
- ✅ Rate limiting en Nginx (opcional)

## 📊 Monitoreo

### Comandos Útiles

```bash
# Estado del sistema
docker stats
df -h
free -h

# Logs de acceso Nginx
sudo tail -f /var/log/nginx/access.log

# Monitoreo de puertos
sudo netstat -tlnp | grep :443
sudo netstat -tlnp | grep :80
```

## 🔄 Actualizaciones

```bash
# Actualizar código
git pull origin main

# Reconstruir y desplegar
docker-compose -f docker-compose.vps.yml down
docker-compose -f docker-compose.vps.yml up --build -d

# Verificar actualización
curl -I https://obratec.app
```

## 📞 Soporte

Para problemas o consultas:

1. Revisar logs de contenedores
2. Verificar configuración de DNS
3. Comprobar certificados SSL
4. Validar variables de entorno
5. Revisar workflows N8N

## 📄 Licencia

MIT License - Ver archivo LICENSE para más detalles.

---

**🔗 Enlaces Importantes:**
- [Documentación N8N](https://docs.n8n.io/)
- [API OpenAI](https://platform.openai.com/docs/)
- [Gmail API](https://developers.google.com/gmail/api)
- [Let's Encrypt](https://letsencrypt.org/)
- [Docker Compose](https://docs.docker.com/compose/)