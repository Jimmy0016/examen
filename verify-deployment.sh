#!/bin/bash

# Script de verificación completa del despliegue
echo "🔍 Verificando despliegue completo de Espinoza CI/CD..."

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# URL base
BASE_URL="http://espinoza.byronrm.com"

echo -e "\n${YELLOW}1. Verificando conectividad básica...${NC}"
if curl -s --connect-timeout 10 "$BASE_URL" > /dev/null; then
    echo -e "${GREEN}✅ Sitio web accesible${NC}"
else
    echo -e "${RED}❌ Sitio web no accesible${NC}"
    exit 1
fi

echo -e "\n${YELLOW}2. Verificando health endpoint...${NC}"
HEALTH_RESPONSE=$(curl -s "$BASE_URL/health")
if echo "$HEALTH_RESPONSE" | grep -q "healthy"; then
    echo -e "${GREEN}✅ Health check OK${NC}"
    echo "   Respuesta: $HEALTH_RESPONSE"
else
    echo -e "${RED}❌ Health check falló${NC}"
    echo "   Respuesta: $HEALTH_RESPONSE"
fi

echo -e "\n${YELLOW}3. Verificando API de IA...${NC}"
AI_RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" \
    -d '{"prompt":"¿Qué es CI/CD?"}' \
    "$BASE_URL/api/reply")

if echo "$AI_RESPONSE" | grep -q "reply"; then
    echo -e "${GREEN}✅ API de IA funcionando${NC}"
    echo "   Respuesta: $(echo "$AI_RESPONSE" | jq -r '.reply' 2>/dev/null || echo "$AI_RESPONSE")"
else
    echo -e "${RED}❌ API de IA falló${NC}"
    echo "   Respuesta: $AI_RESPONSE"
fi

echo -e "\n${YELLOW}4. Verificando DNS...${NC}"
DNS_RESULT=$(nslookup espinoza.byronrm.com | grep "Address" | tail -1)
if [ ! -z "$DNS_RESULT" ]; then
    echo -e "${GREEN}✅ DNS configurado correctamente${NC}"
    echo "   $DNS_RESULT"
else
    echo -e "${RED}❌ DNS no configurado${NC}"
fi

echo -e "\n${YELLOW}5. Verificando headers HTTP...${NC}"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL")
if [ "$HTTP_STATUS" = "200" ]; then
    echo -e "${GREEN}✅ HTTP Status: $HTTP_STATUS${NC}"
else
    echo -e "${RED}❌ HTTP Status: $HTTP_STATUS${NC}"
fi

echo -e "\n${YELLOW}6. Test de carga básico...${NC}"
LOAD_TEST_RESULT=$(curl -s -w "Tiempo de respuesta: %{time_total}s\n" "$BASE_URL" -o /dev/null)
echo "   $LOAD_TEST_RESULT"

echo -e "\n${GREEN}🎉 Verificación completa finalizada!${NC}"
echo -e "\n${YELLOW}URLs para verificar manualmente:${NC}"
echo "   • Sitio web: $BASE_URL"
echo "   • Health: $BASE_URL/health"
echo "   • GitHub Packages: https://github.com/[tu-usuario]/[repo]/pkgs/container/espinoza"

echo -e "\n${YELLOW}Comandos útiles:${NC}"
echo "   • Ver logs: ssh [usuario]@[vps-ip] 'docker service logs espinoza_stack_microai'"
echo "   • Ver servicios: ssh [usuario]@[vps-ip] 'docker stack services espinoza_stack'"
echo "   • Reiniciar: ssh [usuario]@[vps-ip] 'docker stack rm espinoza_stack && docker stack deploy -c /tmp/docker-stack-espinoza.yml espinoza_stack'"