# Proyecto CI/CD - Espinoza

## Configuración del Proyecto

### 1. Repositorio GitHub
- Crear repositorio en GitHub
- Crear rama `espinoza` y empujar todo el código
- La rama `espinoza` será la única rama de desarrollo

### 2. Secrets de GitHub Actions
Configurar en Settings → Secrets & variables → Actions:

- `CR_PAT`: Personal Access Token con permisos de packages:write
- `VPS_HOST`: IP pública del VPS
- `VPS_USER`: Usuario SSH (ej: ubuntu)
- `VPS_SSH_KEY`: Clave privada SSH (sin passphrase)
- `VPS_SSH_PORT`: Puerto SSH (opcional, default: 22)

### 3. Verificación
- Comprobar GitHub Packages (GHCR) para ver `espinoza:1.0.5` después del push
- Configurar DNS: crear registro A para `espinoza.byronrm.com` → IP del VPS
- Verificar con: `curl http://espinoza.byronrm.com:1001/`

### 4. Aplicación
- Flask app con AI backend
- Contenedor Docker
- Tests automatizados
- CI/CD pipeline completo