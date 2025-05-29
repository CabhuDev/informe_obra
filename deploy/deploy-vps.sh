#!/bin/bash

# Script de despliegue automático para VPS Hostinger - obratec.app
# Ejecutar como: ./deploy-vps.sh

set -e

echo "🚀 Iniciando despliegue en VPS obratec.app..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes coloreados
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar si estamos en el directorio correcto
if [ ! -f "docker-compose.vps.yml" ]; then
    print_error "No se encontró docker-compose.vps.yml. ¿Estás en el directorio correcto?"
    exit 1
fi

# Verificar si existe el archivo .env
if [ ! -f ".env" ]; then
    print_warning "No se encontró archivo .env"
    echo "Copiando .env.vps.example como .env..."
    cp .env.vps.example .env
    print_warning "¡IMPORTANTE! Edita el archivo .env con tus valores reales antes de continuar."
    print_warning "Ejecuta: nano .env"
    read -p "¿Has configurado el archivo .env? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Configura el archivo .env y vuelve a ejecutar el script."
        exit 1
    fi
fi

# Verificar variables obligatorias
print_status "Verificando variables de entorno..."
source .env

required_vars=("OPENAI_API_KEY" "GMAIL_USER" "N8N_ENCRYPTION_KEY" "WEBHOOK_URL")
missing_vars=()

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ] || [ "${!var}" = "tu-valor-aqui" ] || [ "${!var}" = "tu-clave-openai-aqui" ]; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -ne 0 ]; then
    print_error "Las siguientes variables no están configuradas:"
    printf '%s\n' "${missing_vars[@]}"
    print_error "Edita el archivo .env y vuelve a ejecutar."
    exit 1
fi

print_success "Variables de entorno verificadas ✓"

# Detener contenedores existentes si los hay
print_status "Deteniendo contenedores existentes..."
docker-compose -f docker-compose.vps.yml down 2>/dev/null || true

# Limpiar imágenes antiguas
print_status "Limpiando imágenes antiguas..."
docker system prune -f 2>/dev/null || true

# Construir imágenes
print_status "Construyendo imágenes Docker..."
docker-compose -f docker-compose.vps.yml build --no-cache

# Iniciar servicios
print_status "Iniciando servicios..."
docker-compose -f docker-compose.vps.yml up -d

# Esperar a que los servicios estén listos
print_status "Esperando a que los servicios estén listos..."
sleep 30

# Verificar estado de los contenedores
print_status "Verificando estado de los contenedores..."
if docker-compose -f docker-compose.vps.yml ps | grep -q "Up"; then
    print_success "Contenedores iniciados correctamente ✓"
else
    print_error "Algunos contenedores no se iniciaron correctamente"
    docker-compose -f docker-compose.vps.yml ps
    exit 1
fi

# Mostrar logs de los últimos minutos
print_status "Últimos logs del sistema:"
docker-compose -f docker-compose.vps.yml logs --tail=20

print_success "🎉 ¡Despliegue completado!"
echo ""
echo "📊 Estado del sistema:"
docker-compose -f docker-compose.vps.yml ps
echo ""
echo "🌐 URLs de acceso:"
echo "  Frontend: http://obratec.app:3000"
echo "  N8N: http://obratec.app:5678"
echo "  Con Nginx configurado:"
echo "  Frontend: https://obratec.app"
echo "  N8N: https://obratec.app/n8n/"
echo ""
echo "📝 Comandos útiles:"
echo "  Ver logs: docker-compose -f docker-compose.vps.yml logs -f"
echo "  Detener: docker-compose -f docker-compose.vps.yml down"
echo "  Reiniciar: docker-compose -f docker-compose.vps.yml restart"
echo ""
print_warning "No olvides configurar Nginx como proxy reverso para acceso externo."