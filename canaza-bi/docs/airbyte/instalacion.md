# Instalación de Airbyte

## Prerrequisitos

- Docker Desktop corriendo
- PowerShell como Administrador

## Paso 1: Instalar abctl

```powershell
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/airbytehq/abctl/releases/latest"
$asset = $release.assets | Where-Object { $_.name -like "*windows-amd64.zip" } | Select-Object -First 1
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile "$env:TEMP\abctl.zip"
Expand-Archive -Path "$env:TEMP\abctl.zip" -DestinationPath "C:\abctl" -Force
$abctlExe = Get-ChildItem -Path "C:\abctl" -Filter "abctl.exe" -Recurse | Select-Object -First 1 -ExpandProperty FullName
$abctlDir = Split-Path $abctlExe -Parent
$env:Path += ";$abctlDir"
[Environment]::SetEnvironmentVariable("Path", $env:Path, "Machine")
abctl version
```

## Paso 2: Desplegar Airbyte local

```powershell
mkdir C:\Users\$env:USERNAME\.airbyte\abctl\data -Force
abctl local install --port 8010
abctl local credentials
```

Airbyte queda disponible en: **http://localhost:8010**