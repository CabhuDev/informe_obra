# Usar imagen base de N8N
FROM n8nio/n8n:latest

# Cambiar a usuario root para instalar dependencias
USER root

# Instalar dependencias del sistema
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
    curl

# Variables de entorno para Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos del proyecto
COPY public/ /app/public/

# Instalar dependencias de Node.js
COPY package*.json ./
RUN npm install --only=production

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
    GENERIC_TIMEZONE=Europe/Madrid

# Script de inicio
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Crear directorio para datos de N8N
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n

# Crear directorio temporal para workflows
RUN mkdir -p /tmp/n8n-workflows

# Copiar workflows si existen (usando un patrón que funcione)
COPY n8n /tmp/n8n-workflows/ 

# Mover workflows al directorio correcto
RUN if [ -d "/tmp/n8n-workflows" ]; then \
      cp -r /tmp/n8n-workflows/* /home/node/.n8n/ 2>/dev/null || true; \
      chown -R node:node /home/node/.n8n; \
    fi

# Volver al usuario n8n
USER node

# Exponer puerto para Render (puerto dinámico)
EXPOSE 10000

ENTRYPOINT ["/docker-entrypoint.sh"]
