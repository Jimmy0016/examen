Crear repositorio en GitHub.

Crear rama espinoza y empujar todo.

Crear secrets en Settings → Secrets & variables → Actions:

CR_PAT (PAT con paquetes: write)

VPS_HOST (IP pública del VPS)

VPS_USER (usuario SSH, p. ej. ubuntu)

VPS_SSH_KEY (clave privada SSH, sin passphrase o usar ssh-agent)

VPS_SSH_PORT (opcional; 22)

Comprobar GitHub Packages (GHCR) para ver espinoza:1.0.5 después del push.

Configurar DNS: crear un registro A para espinoza.byronrm.com apuntando a la IP del VPS.

Verificar con curl http://espinoza.byronrm.com/.