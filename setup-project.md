# Guía de Configuración del Proyecto

## Pasos para Configurar el Proyecto Completo

### 1. Crear Repositorio en GitHub
```bash
# Crear repositorio en GitHub (via web interface)
# Nombre sugerido: examen100-espinoza

# Clonar y configurar
git clone https://github.com/[tu-usuario]/examen100-espinoza.git
cd examen100-espinoza

# Copiar todos los archivos del proyecto aquí
# Hacer commit inicial
git add .
git commit -m "Initial project setup with Flask AI app and CI/CD"

# Crear y cambiar a rama espinoza
git checkout -b espinoza
git push -u origin espinoza
```

### 2. Configurar GitHub Secrets
En GitHub → Settings → Secrets and variables → Actions, agregar:

- **CR_PAT**: 
  - Ir a GitHub → Settings → Developer settings → Personal access tokens
  - Crear token con permisos: `write:packages`, `read:packages`
  
- **VPS_HOST**: IP pública de tu VPS (ej: `203.0.113.1`)

- **VPS_USER**: Usuario SSH (ej: `ubuntu`)

- **VPS_SSH_KEY**: 
  ```bash
  # Generar clave SSH (si no tienes)
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/vps_key -N ""
  
  # Copiar clave pública al VPS
  ssh-copy-id -i ~/.ssh/vps_key.pub ubuntu@[VPS_IP]
  
  # Usar clave privada como secret
  cat ~/.ssh/vps_key
  ```

- **VPS_SSH_PORT**: `22` (o el puerto que uses)

### 3. Preparar VPS
```bash
# Conectar al VPS
ssh ubuntu@[VPS_IP]

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu

# Inicializar Docker Swarm
sudo docker swarm init

# Instalar curl (para health checks)
sudo apt update && sudo apt install -y curl

# Logout y login para aplicar cambios de grupo
exit
ssh ubuntu@[VPS_IP]
```

### 4. Configurar DNS
En tu proveedor de DNS (ej: Cloudflare, Route53):
- Crear registro A: `espinoza.byronrm.com` → IP del VPS

### 5. Primer Despliegue
```bash
# Hacer push a rama espinoza para activar CI/CD
git push origin espinoza

# Monitorear en GitHub Actions
# Verificar imagen en GitHub Packages
# Verificar despliegue en VPS
```

### 6. Verificación Final
```bash
# Health check
curl http://espinoza.byronrm.com/health

# Test completo
curl -X POST -H "Content-Type: application/json" \
  -d '{"prompt":"Hola, ¿cómo funciona CI/CD?"}' \
  http://espinoza.byronrm.com/api/reply

# Verificar en navegador
open http://espinoza.byronrm.com
```

## Troubleshooting

### Si el despliegue falla:
```bash
# Conectar al VPS y verificar
ssh ubuntu@[VPS_IP]
docker stack ls
docker stack services espinoza_stack
docker service logs espinoza_stack_microai
```

### Si la imagen no se publica:
- Verificar que CR_PAT tenga permisos correctos
- Verificar que el repositorio permita packages
- Revisar logs de GitHub Actions

### Si el DNS no resuelve:
- Verificar propagación: `nslookup espinoza.byronrm.com`
- Puede tomar hasta 24h en propagarse completamente