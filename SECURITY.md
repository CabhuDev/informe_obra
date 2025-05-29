# 🔐 Guía de Seguridad - Sistema Obratec

## ⚠️ INFORMACIÓN IMPORTANTE DE SEGURIDAD

### 🚨 CREDENCIALES SENSIBLES

Este proyecto maneja credenciales sensibles que **NUNCA** deben ser expuestas públicamente:

- **OpenAI API Keys** - Para transcripción de audio
- **Google OAuth2 Credentials** - Para envío de emails  
- **N8N Authentication** - Para acceso al panel de administración
- **Certificados SSL** - Para HTTPS

### 📋 CONFIGURACIÓN SEGURA

#### 1. Variables de Entorno (.env)
```bash
# ✅ CORRECTO - Usar archivo .env (incluido en .gitignore)
OPENAI_API_KEY=sk-your-actual-key-here
GOOGLE_OAUTH_CLIENT_ID=your-client-id.apps.googleusercontent.com

# ❌ INCORRECTO - NUNCA hardcodear en el código
const apiKey = "sk-1234567890abcdef"  // ¡NO HACER ESTO!
```

#### 2. Archivos Seguros
- ✅ `.env` - Variables de entorno (Git ignored)
- ✅ `.env.template` - Plantilla sin valores reales
- ✅ `.env.example` - Ejemplo con placeholders
- ❌ `.env.production` - Si contiene valores reales

#### 3. Git y GitHub
```bash
# Verificar que .gitignore incluye:
.env
.env.*
*.key
*.pem
config/local.json
```

### 🛡️ MEJORES PRÁCTICAS

#### Para Desarrolladores
1. **Nunca commits credenciales reales**
2. **Usar .env.template para documentación**
3. **Rotar credenciales regularmente**
4. **Usar secrets managers en producción**

#### Para Despliegue
1. **Variables de entorno del sistema**
2. **Docker secrets**
3. **Kubernetes secrets**
4. **Servicios de gestión de secretos (AWS Secrets Manager, etc.)**

### 🔍 AUDITORÍA DE SEGURIDAD

#### Verificación Manual
```powershell
# Buscar posibles credenciales expuestas
git log --all --grep="password\|secret\|key\|token" -i
git log --all -S "sk-" --source --all
git log --all -S "GOCSPX" --source --all
```

#### GitHub Secret Scanning
- ✅ Habilitado automáticamente
- ✅ Bloquea push con credenciales
- ✅ Alertas de seguridad automáticas

### 🚨 QUÉ HACER SI SE EXPONE UNA CREDENCIAL

#### Respuesta Inmediata
1. **Rotar la credencial inmediatamente**
2. **Revocar acceso a la credencial antigua**
3. **Revisar logs de acceso**
4. **Notificar al equipo**

#### Para OpenAI API Keys
1. Ir a https://platform.openai.com/api-keys
2. Revocar la key comprometida
3. Generar nueva key
4. Actualizar .env

#### Para Google OAuth2
1. Ir a Google Cloud Console
2. Revocar las credenciales antiguas
3. Generar nuevas credenciales
4. Actualizar configuración

#### Para N8N
1. Cambiar contraseña de administrador
2. Revisar logs de acceso
3. Verificar workflows no autorizados

### 📧 CONFIGURACIÓN GMAIL SEGURA

#### Permisos Mínimos
```
Scope: https://www.googleapis.com/auth/gmail.send
```
- ✅ Solo envío de emails
- ❌ No lectura de emails
- ❌ No acceso completo a Gmail

#### OAuth2 Flow Seguro
1. Usar refresh tokens
2. Tokens de acceso de corta duración
3. Validar redirect URIs

### 🐳 SEGURIDAD EN DOCKER

#### Variables de Entorno
```yaml
# docker-compose.yml
services:
  app:
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
    # ❌ NO hacer:
    # environment:
    #   - OPENAI_API_KEY=sk-hardcoded-key
```

#### Secrets de Docker
```yaml
services:
  app:
    secrets:
      - openai_key
secrets:
  openai_key:
    file: ./secrets/openai_key.txt
```

### 🔐 N8N SECURITY

#### Autenticación Básica
- ✅ Siempre habilitada en producción
- ✅ Contraseñas fuertes (mínimo 16 caracteres)
- ✅ HTTPS obligatorio

#### Webhooks Seguros
- ✅ Validación de origen
- ✅ Rate limiting
- ✅ Logs de acceso

### 📊 MONITOREO DE SEGURIDAD

#### Logs a Revisar
```bash
# Intentos de acceso no autorizado
grep "401\|403" /var/log/nginx/access.log

# Conexiones sospechosas
grep "suspicious\|attack" /var/log/system.log
```

#### Alertas Automáticas
- Intentos de login fallidos en N8N
- Uso excesivo de API (OpenAI)
- Conexiones desde IPs inusuales

### 📞 CONTACTO DE SEGURIDAD

Si encuentras una vulnerabilidad de seguridad:
1. **NO crear issue público**
2. Contactar por email privado
3. Describir la vulnerabilidad
4. Esperar confirmación antes de divulgar

---
*Última actualización: Mayo 2025*
