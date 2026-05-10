# Script exportar_eve_por_escenario.sh

## 1. Proposito del script
El script `exportar_eve_por_escenario.sh` sirve para copiar el archivo `eve.json` generado por Suricata y guardarlo con un nombre estandar por escenario y por corrida. Su funcion principal es separar las capturas del laboratorio para que luego puedan parsearse, etiquetarse y analizarse con trazabilidad.

Este script se usa para evitar que todo quede mezclado en un solo `eve.json` continuo.

## 2. Ruta donde debe crearse
Partiendo desde este prompt:

```bash
root@sensor:/home/m4rk/ppi-surikata-producto/scripts#
```

el script debe ubicarse en:

```bash
/home/m4rk/ppi-surikata-producto/scripts/capture/
```

Nombre final del archivo:

```bash
/home/m4rk/ppi-surikata-producto/scripts/capture/exportar_eve_por_escenario.sh
```

## 3. Comandos para crear la carpeta
Desde:

```bash
root@sensor:/home/m4rk/ppi-surikata-producto/scripts#
```

ejecutar:

```bash
mkdir -p /home/m4rk/ppi-surikata-producto/scripts/capture
mkdir -p /home/m4rk/ppi-surikata-producto/data/raw
```

## 4. Comando para crear el archivo
Ejecutar:

```bash
nano /home/m4rk/ppi-surikata-producto/scripts/capture/exportar_eve_por_escenario.sh
```

## 5. Contenido del script
Pegar este contenido dentro del archivo:

```bash
#!/usr/bin/env bash

set -euo pipefail

SOURCE_EVE="/var/log/suricata/eve.json"
TARGET_DIR="/home/m4rk/ppi-surikata-producto/data/raw"

if [ "$#" -ne 4 ]; then
  echo "Uso: $0 <fecha> <grupo> <escenario> <corrida>"
  echo "Ejemplo: $0 20260510 normal http 01"
  exit 1
fi

FECHA="$1"
GRUPO="$2"
ESCENARIO="$3"
CORRIDA="$4"

OUTPUT_FILE="${FECHA}_${GRUPO}_${ESCENARIO}_${CORRIDA}_eve.json"

mkdir -p "$TARGET_DIR"

if [ ! -f "$SOURCE_EVE" ]; then
  echo "No existe el archivo fuente: $SOURCE_EVE"
  exit 1
fi

cp "$SOURCE_EVE" "$TARGET_DIR/$OUTPUT_FILE"

echo "Archivo exportado a: $TARGET_DIR/$OUTPUT_FILE"
```

## 6. Guardar y salir de nano
En `nano`:
- `Ctrl + O` para guardar
- `Enter` para confirmar
- `Ctrl + X` para salir

## 7. Dar permisos de ejecucion
Ejecutar:

```bash
chmod +x /home/m4rk/ppi-surikata-producto/scripts/capture/exportar_eve_por_escenario.sh
```

## 8. Ajustar propietario recomendado
Si trabajas como `root`, ajusta el propietario:

```bash
chown m4rk:m4rk /home/m4rk/ppi-surikata-producto/scripts/capture/exportar_eve_por_escenario.sh
chown -R m4rk:m4rk /home/m4rk/ppi-surikata-producto/data/raw
```

## 9. Como ejecutarlo
Ejemplo de ejecucion:

```bash
/home/m4rk/ppi-surikata-producto/scripts/capture/exportar_eve_por_escenario.sh 20260510 normal http 01
```

## 10. Que archivo genera
El script genera una copia del `eve.json` actual con nombre estandar dentro de:

```bash
/home/m4rk/ppi-surikata-producto/data/raw/
```

Ejemplo de archivo generado:

```bash
/home/m4rk/ppi-surikata-producto/data/raw/20260510_normal_http_01_eve.json
```

## 11. Como verificar el resultado
Ejecutar:

```bash
ls -lh /home/m4rk/ppi-surikata-producto/data/raw/
```

o para revisar un archivo concreto:

```bash
ls -lh /home/m4rk/ppi-surikata-producto/data/raw/20260510_normal_http_01_eve.json
```

## 12. Convencion de nombres usada
El archivo sigue este patron:

```text
YYYYMMDD_grupo_escenario_corrida_eve.json
```

### Significado de cada parte
- `YYYYMMDD` -> fecha de ejecucion
- `grupo` -> normal / anomalo / mixto
- `escenario` -> nombre corto del escenario
- `corrida` -> numero de repeticion

## 13. Cuando debe ejecutarse
Este script debe ejecutarse:
- al terminar cada escenario;
- antes de lanzar el siguiente escenario;
- despues de haber confirmado que Suricata sigue escribiendo en `eve.json`.

## 14. Relacion con otros scripts
Este script se usa en conjunto con:

### Antes
- el script del escenario que genera trafico

### Despues
- `registrar_bitacora.sh`

Flujo esperado:

```text
script de escenario -> exportar_eve_por_escenario.sh -> registrar_bitacora.sh
```

## 15. Resumen corto
### Este script sirve para:
- separar la captura por escenario y corrida.

### Se crea en:
- `scripts/capture/`

### Genera:
- una copia de `eve.json` en `data/raw/`

### Debe ejecutarse:
- al finalizar cada escenario.
