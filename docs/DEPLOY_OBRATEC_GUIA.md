# 🚀 Guía de Despliegue VPS - obratec.app

## ✅ **Sistema Configurado Para:**
- **Dominio**: obratec.app
- **IP VPS**: 31.97.36.248  
- **Subdominio N8N**: n8n.obratec.app
- **Plataforma**: Hostinger VPS + Ubuntu

## 📋 **URLs Finales del Sistema**
- **🌐 Frontend**: `https://obratec.app`
- **⚙️ N8N Admin**: `https://n8n.obratec.app`
- **🔗 Webhook**: `https://obratec.app/webhook/form-obra`
- **💊 Health Check**: `https://obratec.app/health`

---

## 🛠️ **PASO 1: Preparar Código (En tu PC)**

### 1.1 Ejecutar Script de Preparación
```powershell
# En PowerShell (directorio del proyecto)
.\prepare-obratec.ps1
```

### 1.2 Configurar Variables de Entorno
```bash
# Editar .env con tus datos reales
notepad .env

# Configura estas variables OBLIGATORIAS:
OPENAI_API_KEY=sk-tu-clave-real-de-openai
GMAIL_USER=tu-email@gmail.com
GMAIL_PASSWORD=tu-contraseña-aplicacion-gmail
GMAIL_CLIENT_ID=tu-client-id-google
GMAIL_CLIENT_SECRET=tu-client-secret
N8N_ENCRYPTION_KEY=Wz9gP4tUx93bQ7nCa6yV0eZ2LpR1HsKD
```

### 1.3 Subir a GitHub
```bash
git add .
git commit -m "Configuración VPS obratec.app lista"
git push origin main
```

---

## 🖥️ **PASO 2: Configurar VPS (En tu servidor)**

### 2.1 Conectar al VPS
```bash
ssh root@31.97.36.248
# o si tienes usuario específico:
ssh usuario@31.97.36.248
```

### 2.2 Instalar Dependencias (Solo primera vez)
```bash
# Actualizar sistema
apt update && apt upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Instalar Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Instalar Nginx y Certbot
apt install -y nginx certbot python3-certbot-nginx

# Verificar instalaciones
docker --version
docker-compose --version
nginx -v
```

### 2.3 Clonar Proyecto
```bash
cd /opt
git clone https://github.com/TU-USUARIO/informe_obra.git
cd informe_obra

# Dar permisos
chown -R $USER:$USER /opt/informe_obra
chmod +x deploy-vps.sh
```

### 2.4 Configurar Variables de Entorno
```bash
# Copiar template
cp .env.vps.example .env

# Editar con tus datos reales
nano .env
```

### 2.5 Desplegar Aplicación
```bash
# Ejecutar script de despliegue
./deploy-vps.sh
```

---

## 🌐 **PASO 3: Configurar Nginx + HTTPS**

### 3.1 Configurar Nginx
```bash
# Copiar configuración
cp nginx.conf.example /etc/nginx/sites-available/obratec.app

# Activar sitio
ln -s /etc/nginx/sites-available/obratec.app /etc/nginx/sites-enabled/

# Desactivar sitio por defecto
rm /etc/nginx/sites-enabled/default

# Verificar configuración
nginx -t

# Reiniciar Nginx
systemctl restart nginx
```

### 3.2 Configurar HTTPS (Let's Encrypt)
```bash
# Obtener certificados SSL
certbot --nginx -d obratec.app -d www.obratec.app -d n8n.obratec.app

# Verificar renovación automática
certbot renew --dry-run
```

### 3.3 Configurar Firewall
```bash
# Configurar UFW
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable

# Ver estado
ufw status
```

---

## ⚙️ **PASO 4: Configurar N8N**

### 4.1 Acceder a N8N
1. Ve a `https://n8n.obratec.app`
2. No hay autenticación configurada (acceso directo)

### 4.2 Importar Workflow
1. En N8N, ve a **Workflows** → **Import from file**
2. Sube el archivo `n8n/workflows/informe_obra_n8n_workflow.json`
3. **Activa** el workflow

### 4.3 Verificar Configuración
- **Webhook URL**: Debe ser `https://obratec.app/webhook/form-obra`
- **OpenAI Node**: Verificar que la API key esté configurada
- **Gmail Node**: Configurar OAuth2 si es necesario

---

## 🔧 **PASO 5: Verificación Final**

### 5.1 Verificar Servicios
```bash
# Ver estado de contenedores
docker-compose -f docker-compose.vps.yml ps

# Ver logs en tiempo real
docker-compose -f docker-compose.vps.yml logs -f

# Verificar puertos
netstat -tulpn | grep -E ':80|:443|:3000|:5678'
```

### 5.2 Probar Endpoints
```bash
# Frontend
curl -I https://obratec.app

# N8N
curl -I https://n8n.obratec.app

# Webhook
curl -I https://obratec.app/webhook/form-obra

# Health Check
curl https://obratec.app/health
```

### 5.3 Probar Formulario Completo
1. Ve a `https://obratec.app`
2. Rellena el formulario de informe
3. Graba un audio de prueba
4. Envía el formulario
5. Verifica que llegue el email

---

## 📊 **Comandos de Mantenimiento**

### Ver Logs
```bash
# Logs de aplicación
docker-compose -f docker-compose.vps.yml logs -f app

# Logs de N8N
docker-compose -f docker-compose.vps.yml logs -f n8n

# Logs de Nginx
tail -f /var/log/nginx/obratec.access.log
tail -f /var/log/nginx/obratec.error.log
```

### Actualizar Sistema
```bash
cd /opt/informe_obra
git pull origin main
./deploy-vps.sh
```

### Backup de Datos N8N
```bash
# Hacer backup
docker cp obratec-n8n:/home/node/.n8n ./backup-n8n-$(date +%Y%m%d)

# Restaurar backup
docker cp ./backup-n8n-20250528 obratec-n8n:/home/node/.n8n
```

### Reiniciar Servicios
```bash
# Reiniciar todo
docker-compose -f docker-compose.vps.yml restart

# Reiniciar solo un servicio
docker-compose -f docker-compose.vps.yml restart app
docker-compose -f docker-compose.vps.yml restart n8n
```

---

## 🔥 **Troubleshooting**

### Problema: N8N no arranca
```bash
# Ver logs específicos
docker-compose -f docker-compose.vps.yml logs n8n

# Verificar variables de entorno
docker-compose -f docker-compose.vps.yml exec n8n env | grep N8N
```

### Problema: Frontend no accesible
```bash
# Verificar estado de app
docker-compose -f docker-compose.vps.yml ps app

# Ver logs de aplicación
docker-compose -f docker-compose.vps.yml logs app

# Verificar Nginx
nginx -t
systemctl status nginx
```

### Problema: HTTPS no funciona
```bash
# Verificar certificados
certbot certificates

# Renovar certificados
certbot renew

# Ver logs de certbot
tail -f /var/log/letsencrypt/letsencrypt.log
```

### Problema: No llegan emails
```bash
# Verificar configuración de Gmail en N8N
# Asegúrate de que:
# 1. GMAIL_USER esté configurado
# 2. GMAIL_CLIENT_ID y GMAIL_CLIENT_SECRET sean correctos
# 3. OAuth2 esté configurado en Google Cloud Console
```

---

## 🎉 **¡Sistema Completamente Desplegado!**

Tu sistema de **Informes de Obra** está ahora funcionando profesionalmente en:

### **🌐 https://obratec.app**

Con todas las funcionalidades:
- ✅ **Formulario responsive** para informes
- ✅ **Grabación de audio** integrada  
- ✅ **Transcripción automática** con OpenAI
- ✅ **Generación de informes** con IA
- ✅ **Envío automático por email**
- ✅ **Interfaz N8N** para gestión
- ✅ **HTTPS seguro** con certificados automáticos
- ✅ **Alta disponibilidad** 24/7

### **📈 Rendimiento Profesional**
- **VPS dedicado** con recursos garantizados
- **Sin limitaciones** de tiempo de ejecución
- **Dominio personalizado** profesional
- **Backups automáticos** de datos
- **Monitoreo y logs** completos

---

**📞 Soporte**: Si tienes problemas, revisa los logs con:
```bash
docker-compose -f docker-compose.vps.yml logs -f
```
