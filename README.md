# 🏗️ Sistema de Informes de Obra Automatizado

Un sistema completo de automatización de informes de construcción que utiliza N8N para workflows, transcripción con IA, y envío automático de emails.

## 🌐 Acceso al Sistema

- **Aplicación Principal**: https://obratec.app
- **Panel N8N**: https://n8n.obratec.app
- **Servidor VPS**: 31.97.36.248 (Hostinger)

## ✨ Características

- 📝 **Formulario Web**: Captura de datos y audio de informes de obra
- 🤖 **Transcripción IA**: Conversión automática de audio a texto usando OpenAI
- ⚡ **Automatización N8N**: Workflows automáticos para procesamiento de datos
- 📧 **Envío Automático**: Emails automáticos con informes formateados
- 🔐 **HTTPS Seguro**: Certificados SSL Let's Encrypt
- 🐳 **Dockerizado**: Despliegue fácil con Docker Compose

## 🛠️ Arquitectura del Sistema

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