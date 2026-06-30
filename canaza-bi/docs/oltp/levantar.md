# Cómo levantar el entorno OLTP

## Prerrequisitos

- Docker Desktop instalado y corriendo
- Repositorio clonado en `D:\261bi\canaza-bi\`

## Comandos

```powershell
cd D:\261bi\canaza-bi\oltp-mysql
docker compose up -d
docker ps
```

## Verificar que está corriendo

Debes ver el contenedor `canaza-oltp-mysql` en estado `Up` con el puerto `13306`.

## Conectar desde VS Code

Usa la extensión MySQL con estos datos:
- Host: localhost
- Port: 13306
- User: root
- Password: root
- Database: canaza_oltp

## Cargar datos

Ejecuta en orden desde VS Code conectado al puerto 13306:

1. `datos_2023_2024.sql` — datos ficticios 2023 y 2024
2. Scripts 02, 03, 04 del repositorio — datos reales 2025-2026

## Siguiente paso

Con el entorno OLTP cargado, el siguiente paso es construir el DataMart
manualmente con los [scripts SQL de la Sesión 6](scripts.md), o continuar
directamente con el pipeline automatizado: [Ingesta Airbyte](../airbyte/instalacion.md).