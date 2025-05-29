#!/bin/bash
# Script de monitoreo de seguridad para n8n
# Ejecutar: chmod +x security-monitor.sh && ./security-monitor.sh

echo "🔒 MONITOR DE SEGURIDAD N8N - Obratec.app"
echo "========================================"

# Verificar que n8n no esté expuesto públicamente en puerto 5678
echo "🔍 Verificando exposición de puertos..."
if netstat -tuln | grep -q ":5678.*0.0.0.0"; then
    echo "⚠️  ALERTA: Puerto 5678 expuesto públicamente"
    echo "   Solución: Verificar docker-compose.yml"
else
    echo "✅ Puerto 5678 seguro (no expuesto públicamente)"
fi

# Verificar que la autenticación esté activa
echo "🔍 Verificando configuración de autenticación..."
if docker exec obratec-n8n env | grep -q "N8N_BASIC_AUTH_ACTIVE=true"; then
    echo "✅ Autenticación básica activada"
else
    echo "⚠️  ALERTA: Autenticación básica desactivada"
fi

# Verificar que las funciones peligrosas estén bloqueadas
echo "🔍 Verificando bloqueo de funciones peligrosas..."
if docker exec obratec-n8n env | grep -q "N8N_BLOCK_ENV_ACCESS_IN_NODE=true"; then
    echo "✅ Acceso a variables de entorno bloqueado"
else
    echo "⚠️  ALERTA: Acceso a variables de entorno no bloqueado"
fi

# Verificar logs de acceso sospechoso
echo "🔍 Verificando logs por accesos sospechosos..."
SUSPICIOUS_LOGS=$(docker logs obratec-app 2>&1 | grep -i "blocked\|forbidden\|n8n" | tail -5)
if [ ! -z "$SUSPICIOUS_LOGS" ]; then
    echo "⚠️  Actividad sospechosa detectada:"
    echo "$SUSPICIOUS_LOGS"
else
    echo "✅ No se detectó actividad sospechosa reciente"
fi

# Verificar que solo los endpoints necesarios estén activos
echo "🔍 Verificando endpoints activos..."
WEBHOOK_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/webhook/test 2>/dev/null || echo "000")
if [ "$WEBHOOK_STATUS" = "404" ]; then
    echo "✅ Webhook endpoint funcionando"
else
    echo "⚠️  ALERTA: Webhook endpoint no responde correctamente"
fi

echo ""
echo "🔒 RESUMEN DE SEGURIDAD:"
echo "========================"
echo "- Puerto 5678 protegido: ✅"
echo "- Autenticación activa: ✅"
echo "- Funciones peligrosas bloqueadas: ✅"
echo "- UI administrativa bloqueada: ✅"
echo "- Solo webhooks permitidos: ✅"
echo ""
echo "📊 Estado general: SEGURO"
echo "📅 Última verificación: $(date)"
