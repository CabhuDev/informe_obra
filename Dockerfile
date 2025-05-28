# Usar imagen base de N8N
FROM n8nio/n8n:latest

# Cambiar a usuario root para instalar dependencias
USER root

# Instalar dependencias del sistema y nginx
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    python3 \
    py3-pip \
    bash \
    curl \
    nginx \
    nodejs \
    npm

# Variables de entorno para Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos del proyecto
COPY public/ /app/public/
COPY server.js /app/
COPY docker-entrypoint.sh /app/
COPY package*.json /app/

# Instalar dependencias de Node.js para el frontend
RUN npm install --only=production

# Copiar workflows de N8N
COPY n8n/ /app/n8n/

# Variables de entorno para N8N
ENV N8N_HOST=0.0.0.0 \
    N8N_PORT=5678 \
    N8N_PROTOCOL=http \
    NODE_ENV=production \
    N8N_USER_MANAGEMENT_DISABLED=true \
    N8N_DIAGNOSTICS_ENABLED=false \
    N8N_VERSION_NOTIFICATIONS_ENABLED=false \
    N8N_TEMPLATES_ENABLED=false \
    N8N_ONBOARDING_FLOW_DISABLED=true \
    EXECUTIONS_DATA_PRUNE=true \
    EXECUTIONS_DATA_MAX_AGE=168 \
    GENERIC_TIMEZONE=Europe/Madrid \
    N8N_METRICS=true \
    N8N_LOG_LEVEL=info

# Configurar nginx
RUN mkdir -p /var/log/nginx /var/lib/nginx/tmp /etc/nginx/conf.d

# Hacer ejecutable el script de inicio
RUN chmod +x /app/docker-entrypoint.sh

# Crear directorio para datos de N8N y logs de aplicación, configurar permisos
RUN mkdir -p /home/node/.n8n/workflows /app/logs && \
    chown -R node:node /home/node/.n8n /app

# Cambiar al usuario node para mayor seguridad
USER node

# Exponer puerto dinámico para Render
EXPOSE ${PORT:-10000}

# Comando de inicio
ENTRYPOINT ["/app/docker-entrypoint.sh"]
