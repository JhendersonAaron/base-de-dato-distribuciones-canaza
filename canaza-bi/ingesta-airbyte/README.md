# Ingesta Airbyte - Distribuciones Canaza E.I.R.L.

## Propósito

Esta carpeta documenta el uso de Airbyte como módulo de ingesta para mover
datos desde la fuente operativa canaza_oltp hacia la base analítica canaza_dw.

## Rol en la arquitectura

MySQL (canaza_oltp) -> Airbyte -> PostgreSQL (canaza_dw.raw)

## Prerequisitos

Antes de usar este módulo deben estar operativos:

- oltp-mysql/ (contenedor canaza-oltp-mysql en puerto 13306)
- dw-pg/ (contenedor canaza-dw-pg en puerto 15432)
- Docker Desktop
- Airbyte local con abctl

## Instalación de Airbyte en Windows

### Paso 1. Instalar abctl

Abre PowerShell como administrador y ejecuta:

```powershell
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/airbytehq/abctl/releases/latest"
$release.assets | Select-Object -ExpandProperty name

$asset = $release.assets | Where-Object { $_.name -like "*windows-amd64.zip" } | Select-Object -First 1
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile "$env:TEMP\abctl.zip"
Expand-Archive -Path "$env:TEMP\abctl.zip" -DestinationPath "C:\abctl" -Force
$abctlExe = Get-ChildItem -Path "C:\abctl" -Filter "abctl.exe" -Recurse | Select-Object -First 1 -ExpandProperty FullName
$abctlDir = Split-Path $abctlExe -Parent
$env:Path += ";$abctlDir"
[Environment]::SetEnvironmentVariable("Path", $env:Path, "Machine")
abctl version
```

### Paso 2. Desplegar Airbyte local

```powershell
mkdir C:\Users\$env:USERNAME\.airbyte\abctl\data -Force
abctl local install --port 8010
abctl local credentials
```

Airbyte queda disponible en: http://localhost:8010

## Configuración de la réplica

### Source MySQL

- Source name: mysql-canaza
- Host: host.docker.internal
- Port: 13306
- Database: canaza_oltp
- Username: root
- Password: root
- Update Method: Scan Changes with User Defined Cursor

### Destination PostgreSQL

- Destination name: postgres-canaza-raw
- Host: host.docker.internal
- Port: 15432
- Database Name: canaza_dw
- Default Schema: raw
- Username: postgres
- Password: postgres
- SSL Modes: disable

### Tablas a sincronizar

- categoria
- comprobante
- comprobante_detalle
- entidad
- producto
- tipo_comprobante
- tipo_documento

### Configuración de conexión

- Connection name: mysql-canaza -> postgres-canaza-raw
- Schedule type: Manual
- Destination Namespace: Destination-defined

## Validación mínima

```powershell
docker exec -it canaza-dw-pg psql -U postgres -d canaza_dw
```

```sql
\dt raw.*
SELECT COUNT(*) FROM raw.comprobante;
SELECT COUNT(*) FROM raw.comprobante_detalle;
SELECT COUNT(*) FROM raw.entidad;
SELECT COUNT(*) FROM raw.producto;
```