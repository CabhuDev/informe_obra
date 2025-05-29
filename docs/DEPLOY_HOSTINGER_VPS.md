# 🚀 Despliegue en Hostinger VPS

## Ventajas del VPS vs Render
- ✅ **Control total** del servidor
- ✅ **Sin limitaciones** de tiempo de ejecución
- ✅ **Mejor rendimiento** (recursos dedicados)
- ✅ **Dominio personalizado** fácil
- ✅ **HTTPS gratuito** con Let's Encrypt
- ✅ **Persistencia** de datos garantizada
- ✅ **Sin dormancy** (siempre activo)

## 📋 Requisitos Previos

### 1. Acceso al VPS
- IP de tu VPS Hostinger
- Usuario root o sudo
- Acceso SSH

### 2. Dominio (Opcional pero recomendado)
- Dominio apuntando a la IP del VPS
- Ejemplo: `informe-obra.tudominio.com`

## 🛠️ Instalación Paso a Paso

### Paso 1: Conectar al VPS
```bash
ssh root@tu-ip-vps
# o si tienes usuario con sudo:
ssh usuario@tu-ip-vps
```

### Paso 2: Actualizar Sistema
```bash
apt update && apt upgrade -y
```

### Paso 3: Instalar Docker y Docker Compose
```bash
# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Instalar Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Verificar instalación
docker --version
docker-compose --version
```

### Paso 4: Instalar Nginx (Proxy Reverso)
```bash
apt install nginx -y
systemctl enable nginx
systemctl start nginx
```

### Paso 5: Instalar Certbot (HTTPS)
```bash
apt install certbot python3-certbot-nginx -y
```

### Paso 6: Clonar tu Repositorio
```bash
cd /opt
git clone https://github.com/CabhuDev/informe_obra.git
cd informe_obra
```

## 📁 Estructura de Archivos para VPS

Vamos a crear archivos específicos para el VPS:

### docker-compose.vps.yml
Ya creado ✅ - Configuración de contenedores para VPS

### .env.vps.example  
Ya creado ✅ - Template de variables de entorno

### deploy-vps.sh
Ya creado ✅ - Script de despliegue automático

### nginx.conf.example
Ya creado ✅ - Configuración de Nginx

## 🚀 Proceso de Despliegue

### Paso 7: Configurar Variables de Entorno
```bash
# Copiar template y editar
cp .env.vps.example .env
nano .env

# Configurar estas variables OBLIGATORIAS:
OPENAI_API_KEY=sk-tu-clave-real-de-openai
GMAIL_USER=tu-email@gmail.com
GMAIL_PASSWORD=tu-contraseña-aplicacion-gmail
N8N_ENCRYPTION_KEY=Wz9gP4tUx93bQ7nCa6yV0eZ2LpR1HsKD
WEBHOOK_URL=https://tudominio.com/webhook/form-obra
```

### Paso 8: Ejecutar Despliegue Automático
```bash
# Dar permisos de ejecución
chmod +x deploy-vps.sh

# Ejecutar despliegue
./deploy-vps.sh
```

### Paso 9: Configurar Nginx (Proxy Reverso)
```bash
# Copiar configuración de Nginx
cp nginx.conf.example /etc/nginx/sites-available/informe-obra

# Editar con tu dominio real
nano /etc/nginx/sites-available/informe-obra
# Cambiar "tudominio.com" por tu dominio real

# Activar sitio
ln -s /etc/nginx/sites-available/informe-obra /etc/nginx/sites-enabled/

# Verificar configuración
nginx -t

# Reiniciar Nginx
systemctl restart nginx
```

### Paso 10: Configurar HTTPS con Let's Encrypt
```bash
# Obtener certificado SSL (cambiar tudominio.com)
certbot --nginx -d tudominio.com -d www.tudominio.com

# Verificar renovación automática
certbot renew --dry-run
```

## 🔧 Configuración Post-Despliegue

### 1. Verificar que todo funciona
```bash
# Ver estado de contenedores
docker-compose -f docker-compose.vps.yml ps

# Ver logs en tiempo real
docker-compose -f docker-compose.vps.yml logs -f

# Probar endpoints
curl https://tudominio.com/health
curl https://tudominio.com/n8n/health
```

### 2. Configurar N8N Workflow
1. Accede a `https://tudominio.com/n8n/`
2. Importa el workflow desde `n8n/workflows/informe_obra_n8n_workflow.json`
3. Activa el workflow

### 3. Configurar Firewall (Seguridad)
```bash
# Instalar UFW
apt install ufw -y

# Configurar reglas básicas
ufw default deny incoming
ufw default allow outgoing

# Permitir SSH, HTTP y HTTPS
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp

# Activar firewall
ufw enable

# Ver estado
ufw status
```

## 📊 Monitoreo y Mantenimiento

### Comandos Útiles
```bash
# Ver logs del sistema
docker-compose -f docker-compose.vps.yml logs -f

# Reiniciar servicios
docker-compose -f docker-compose.vps.yml restart

# Actualizar código
git pull origin main
./deploy-vps.sh

# Backup de datos N8N
docker cp informe-obra-n8n:/home/node/.n8n ./backup-n8n-$(date +%Y%m%d)

# Ver uso de recursos
docker stats
```

### Script de Monitoreo Automático
```bash
# Crear script de monitoreo
cat > /opt/informe_obra/monitor.sh << 'EOF'
#!/bin/bash
cd /opt/informe_obra

# Verificar que los contenedores estén corriendo
if ! docker-compose -f docker-compose.vps.yml ps | grep -q "Up"; then
    echo "⚠️  Reiniciando contenedores..."
    docker-compose -f docker-compose.vps.yml restart
fi

# Limpiar logs antiguos de Docker
docker system prune -f --filter "until=720h"

echo "✅ Monitoreo completado: $(date)"
EOF

chmod +x /opt/informe_obra/monitor.sh

# Añadir a crontab (ejecutar cada hora)
echo "0 * * * * /opt/informe_obra/monitor.sh >> /var/log/informe-obra-monitor.log 2>&1" | crontab -
```

## 🎯 URLs Finales del Sistema

Una vez desplegado, tu sistema estará disponible en:

- **Frontend**: `https://tudominio.com`
- **N8N Interface**: `https://tudominio.com/n8n/`
- **Webhook URL**: `https://tudominio.com/webhook/form-obra`
- **Health Check**: `https://tudominio.com/health`

## 🔧 Troubleshooting

### Problema: N8N no arranca
```bash
# Ver logs específicos de N8N
docker-compose -f docker-compose.vps.yml logs n8n

# Reiniciar solo N8N
docker-compose -f docker-compose.vps.yml restart n8n
```

### Problema: No se pueden subir archivos de audio
```bash
# Verificar límites en Nginx
grep client_max_body_size /etc/nginx/sites-available/informe-obra

# Si es necesario, aumentar límite
sed -i 's/client_max_body_size 50M/client_max_body_size 100M/' /etc/nginx/sites-available/informe-obra
systemctl reload nginx
```

### Problema: Error de certificados SSL
```bash
# Renovar certificados manualmente
certbot renew

# Si falla, regenerar
certbot delete --cert-name tudominio.com
certbot --nginx -d tudominio.com -d www.tudominio.com
```

## 🎉 ¡Listo!

Tu sistema de informes de obra está ahora desplegado profesionalmente en tu VPS de Hostinger con:

- ✅ **HTTPS automático** con Let's Encrypt
- ✅ **Proxy reverso** con Nginx
- ✅ **Alta disponibilidad** con Docker
- ✅ **Monitoreo automático**
- ✅ **Backups configurados**
- ✅ **Firewall de seguridad**

El sistema estará disponible 24/7 con mejor rendimiento que Render y control total sobre la infraestructura.

---

**📞 Soporte**: Si tienes problemas, revisa los logs con:
```bash
docker-compose -f docker-compose.vps.yml logs -f
```
