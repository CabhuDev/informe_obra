# 🏗️ Obratec - Sistema de Informes de Obra con IA

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com/)
[![AI Powered](https://img.shields.io/badge/AI-OpenAI%20Whisper-orange.svg)](https://openai.com/)

Sistema automatizado de informes de construcción con grabación de audio, transcripción AI, generación automática de reportes y envío por email. Diseñado para obras de construcción que necesitan documentar el progreso diario de manera eficiente.

## 🎯 Características Principales

- **📱 Grabación de Audio Nativa**: Compatible con iOS/Android, conversión automática a WAV
- **🤖 Transcripción con IA**: OpenAI Whisper para convertir audio a texto
- **📊 Informes Automáticos**: Generación inteligente de reportes con ChatGPT
- **📧 Envío Automático**: Notificaciones por Gmail con OAuth2
- **🔄 Automatización N8N**: Workflows visuales para procesamiento
- **🚀 Deploy Automático**: Docker + VPS con HTTPS/SSL
- **📱 Mobile-First**: Interfaz optimizada para dispositivos móviles

## 🖼️ Demo

🌐 **Demo en vivo**: [https://obratec.app](https://obratec.app)

![Sistema de Informes](https://img.shields.io/badge/Demo-Live-brightgreen)

## 📁 Estructura del Proyecto

```
obratec-informe-obra/
├── 📄 Archivos principales
│   ├── server.js              # Servidor Node.js principal
│   ├── package.json           # Dependencias del proyecto
│   ├── manage.ps1             # Script gestor del proyecto
│   └── sync-vps.ps1           # Sincronización con VPS
│
├── 📂 public/                 # Frontend de la aplicación
│   ├── index.html             # Interfaz principal
│   ├── js/audioRecord.js      # Grabación y conversión WAV
│   └── css/style.css          # Estilos responsivos
│
├── 📂 n8n/                    # Automatización N8N
│   └── workflows/             # Workflows de IA y email
│
├── 📂 deploy/                 # Despliegue automatizado
│   ├── docker-compose.vps.yml # Configuración Docker
│   ├── Dockerfile             # Imagen del frontend
│   └── deploy-vps.sh          # Script de deploy
│
├── 📂 scripts/                # Scripts de automatización
│   ├── configure-n8n.ps1     # Configuración N8N
│   └── final-setup.ps1       # Setup completo
│
├── 📂 tests/                  # Pruebas del sistema
│   └── test-sistema-wav.ps1   # Test completo con WAV
│
└── 📂 docs/                   # Documentación
    ├── DEPLOY_GUIDE.md        # Guía de despliegue
    └── REORGANIZACION_COMPLETADA.md
```

## 🚀 Inicio Rápido

### Prerrequisitos

- Node.js 18+
- Docker (para deploy)
- Cuenta OpenAI (para transcripción)
- Gmail con OAuth2 (para emails)

### Instalación Local

```bash
# Clonar repositorio
git clone https://github.com/tuusuario/obratec-informe-obra.git
cd obratec-informe-obra

# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus credenciales

# Iniciar servidor
npm start
```

### Despliegue en VPS

```bash
# Configurar VPS
.\scripts\prepare-obratec.ps1

# Desplegar
.\deploy\deploy-vps.sh

# Verificar estado
.\sync-vps.ps1 -DryRun
```

## 🎮 Comandos Principales

| Comando | Descripción |
|---------|-------------|
| `npm start` | Servidor desarrollo |
| `npm test` | Ejecutar pruebas |
| `.\manage.ps1 status` | Estado del sistema |
| `.\manage.ps1 deploy` | Deploy producción |
| `.\tests\test-sistema-wav.ps1` | Test completo |

## 🔧 Tecnologías

### Frontend
- **HTML5**: Estructura semántica
- **CSS3**: Diseño responsivo con Flexbox/Grid
- **JavaScript**: MediaRecorder API, Web Audio API
- **PWA**: Manifest para instalación móvil

### Backend
- **Node.js**: Servidor Express
- **N8N**: Automatización visual de workflows
- **OpenAI**: Whisper (transcripción) + GPT (generación)
- **Gmail API**: Envío automático con OAuth2

### Infraestructura
- **Docker**: Containerización
- **Nginx**: Proxy reverso y SSL
- **Certbot**: Certificados SSL automáticos
- **VPS**: Hostinger/DigitalOcean compatible

## 📱 Flujo de Trabajo

1. **👷 Usuario** completa formulario en móvil/web
2. **🎤 Grabación** de audio nativo en navegador
3. **🔄 Conversión** automática a formato WAV
4. **📤 Envío** a webhook N8N via HTTPS
5. **🤖 Transcripción** con OpenAI Whisper
6. **📊 Generación** de informe con ChatGPT
7. **📧 Envío** automático por Gmail
8. **✅ Confirmación** al usuario

## ⚙️ Configuración

### Variables de Entorno

```env
# Servidor
PORT=3000
NODE_ENV=production

# OpenAI
OPENAI_API_KEY=tu_clave_openai

# Gmail OAuth2
GMAIL_CLIENT_ID=tu_client_id
GMAIL_CLIENT_SECRET=tu_client_secret
GMAIL_REFRESH_TOKEN=tu_refresh_token

# N8N
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=tu_password
```

### N8N Workflows

El sistema incluye workflows preconfigurados para:
- Procesamiento de formularios
- Transcripción de audio
- Generación de informes
- Envío de emails

## 🧪 Testing

```powershell
# Test completo del sistema
.\tests\test-sistema-wav.ps1

# Test conversión WAV
.\tests\test-wav-clean.ps1

# Test webhook N8N
.\tests\test-webhook-clean.ps1
```

## 📊 Monitoreo

- **Logs N8N**: Ejecuciones y errores de workflows
- **Docker Logs**: Estado de contenedores
- **SSL Monitoring**: Renovación automática de certificados
- **Audio Quality**: Validación de conversión WAV

## 🔒 Seguridad

- **HTTPS/SSL**: Certificados automáticos
- **OAuth2**: Autenticación segura Gmail
- **Basic Auth**: Protección N8N
- **Docker**: Aislamiento de servicios
- **Firewall**: Puertos específicos

## 🤝 Contribución

1. Fork el proyecto
2. Crear rama feature (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver [LICENSE](LICENSE) para detalles.

## 👨‍💻 Autor

**Pablo Cabello**
- Email: [tu-email@ejemplo.com]
- LinkedIn: [tu-linkedin]
- GitHub: [@tu-usuario](https://github.com/tu-usuario)

## 🙏 Reconocimientos

- **OpenAI** - Por Whisper y GPT APIs
- **N8N** - Por la plataforma de automatización
- **Node.js Community** - Por las librerías utilizadas
- **Docker** - Por la containerización

## 📈 Roadmap

- [ ] Soporte multi-idioma
- [ ] Dashboard de analytics
- [ ] Integración con más plataformas
- [ ] App móvil nativa
- [ ] API REST completa

---

⭐ **¡Dale una estrella si este proyecto te fue útil!**