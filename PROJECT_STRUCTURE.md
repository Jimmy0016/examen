# Estructura del Proyecto CI/CD - Espinoza

## Descripción General
Proyecto completo de CI/CD con Flask + AI, contenedores Docker y despliegue automático.

## Estructura de Archivos
```
examen100/
├── .github/workflows/
│   ├── ci.yml              # Pipeline CI: tests + build + push
│   └── cd.yml              # Pipeline CD: deploy to VPS
├── app/
│   ├── templates/
│   │   └── index.html      # Frontend web
│   ├── __init__.py
│   ├── main.py             # Flask app principal
│   └── ai_backend.py       # Lógica AI (local + OpenAI opcional)
├── tests/
│   └── test_app.py         # Tests automatizados
├── Dockerfile              # Imagen del contenedor
├── docker-stack.yml        # Stack de Docker Swarm
├── requirements.txt        # Dependencias Python
├── deploy-local.sh         # Script de despliegue local
└── README.md              # Documentación principal
```

## Flujo CI/CD

### CI (Integración Continua)
1. **Trigger**: Push a rama `espinoza`
2. **Tests**: Ejecuta pytest con todos los tests
3. **Build**: Construye imagen Docker `ghcr.io/[owner]/espinoza:1.0.5`
4. **Push**: Publica imagen en GitHub Container Registry

### CD (Despliegue Continuo)
1. **Trigger**: Después de CI exitoso
2. **Deploy**: Conecta al VPS via SSH
3. **Update**: Actualiza Docker Stack con nueva imagen
4. **Verify**: Verifica health endpoint

## Endpoints de la Aplicación

- `GET /` - Página principal con interfaz web
- `GET /health` - Health check (status, service, version)
- `POST /api/reply` - API de AI (recibe prompt, devuelve respuesta)

## Configuración Requerida

### GitHub Secrets
- `CR_PAT`: Personal Access Token con packages:write
- `VPS_HOST`: IP del servidor VPS
- `VPS_USER`: Usuario SSH (ej: ubuntu)
- `VPS_SSH_KEY`: Clave privada SSH
- `VPS_SSH_PORT`: Puerto SSH (opcional)

### DNS
- Registro A: `espinoza.byronrm.com` → IP del VPS

## Comandos Útiles

### Local
```bash
# Construir y probar localmente
./deploy-local.sh

# Ejecutar tests
pytest -v

# Construir imagen
docker build -t espinoza:1.0.5 .
```

### Verificación
```bash
# Health check
curl http://espinoza.byronrm.com/health

# Test AI endpoint
curl -X POST -H "Content-Type: application/json" \
  -d '{"prompt":"¿Qué es CI/CD?"}' \
  http://espinoza.byronrm.com/api/reply
```