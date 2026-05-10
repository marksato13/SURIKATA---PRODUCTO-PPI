# Script registrar_bitacora.sh

## 1. Proposito del script
El script `registrar_bitacora.sh` sirve para registrar de forma estandarizada cada corrida del laboratorio. Su funcion es guardar una linea por escenario ejecutado con informacion clave para la trazabilidad del experimento.

Este script se usa para dejar evidencia de:
- grupo del escenario;
- nombre del escenario;
- origen;
- destino;
- hora de inicio;
- hora de fin;
- herramienta usada;
- archivo `eve.json` exportado.

## 2. Ruta donde debe crearse
Partiendo desde este prompt:

```bash
root@sensor:/home/m4rk/ppi-surikata-producto/scripts#
```

el script debe ubicarse en:

```bash
/home/m4rk/ppi-surikata-producto/scripts/evaluation/
```

Nombre final del archivo:

```bash
/home/m4rk/ppi-surikata-producto/scripts/evaluation/registrar_bitacora.sh
```

## 3. Comandos para crear la carpeta
Desde:

```bash
root@sensor:/home/m4rk/ppi-surikata-producto/scripts#
```

ejecutar:

```bash
mkdir -p /home/m4rk/ppi-surikata-producto/scripts/evaluation
mkdir -p /home/m4rk/ppi-surikata-producto/docs/bitacora
```

## 4. Comando para crear el archivo
Desde el mismo prompt, ejecutar:

```bash
nano /home/m4rk/ppi-surikata-producto/scripts/evaluation/registrar_bitacora.sh
```

## 5. Contenido del script
Pegar este contenido dentro del archivo:

```bash
#!/usr/bin/env bash

set -euo pipefail

BITACORA="/home/m4rk/ppi-surikata-producto/docs/bitacora/bitacora_escenarios.txt"

if [ "$#" -ne 8 ]; then
  echo "Uso: $0 <grupo> <escenario> <origen> <destino> <hora_inicio> <hora_fin> <herramienta> <archivo_salida>"
  exit 1
fi

GRUPO="$1"
ESCENARIO="$2"
ORIGEN="$3"
DESTINO="$4"
HORA_INICIO="$5"
HORA_FIN="$6"
HERRAMIENTA="$7"
ARCHIVO_SALIDA="$8"
FECHA="$(date +%F)"

mkdir -p "$(dirname "$BITACORA")"

echo "${FECHA} | ${GRUPO} | ${ESCENARIO} | ${ORIGEN} -> ${DESTINO} | ${HORA_INICIO} - ${HORA_FIN} | ${HERRAMIENTA} | ${ARCHIVO_SALIDA}" >> "$BITACORA"

echo "Registro agregado a: $BITACORA"
```

## 6. Guardar y salir de nano
En `nano`:
- `Ctrl + O` para guardar
- `Enter` para confirmar
- `Ctrl + X` para salir

## 7. Dar permisos de ejecucion
Ejecutar:

```bash
chmod +x /home/m4rk/ppi-surikata-producto/scripts/evaluation/registrar_bitacora.sh
```

## 8. Ajustar propietario recomendado
Si estas trabajando como `root`, deja el archivo a nombre del usuario del proyecto:

```bash
chown m4rk:m4rk /home/m4rk/ppi-surikata-producto/scripts/evaluation/registrar_bitacora.sh
chown -R m4rk:m4rk /home/m4rk/ppi-surikata-producto/docs/bitacora
```

## 9. Como ejecutarlo
Ejemplo de ejecucion:

```bash
/home/m4rk/ppi-surikata-producto/scripts/evaluation/registrar_bitacora.sh \
normal \
http \
192.168.0.20 \
192.168.0.120 \
10:00:00 \
10:10:00 \
curl_wget \
20260510_normal_http_01_eve.json
```

## 10. Que archivo genera o actualiza
El script no crea un `eve.json`. Lo que hace es actualizar o crear la bitacora en:

```bash
/home/m4rk/ppi-surikata-producto/docs/bitacora/bitacora_escenarios.txt
```

## 11. Como verificar el resultado
Para ver el contenido de la bitacora:

```bash
cat /home/m4rk/ppi-surikata-producto/docs/bitacora/bitacora_escenarios.txt
```

## 12. Ejemplo de salida esperada en la bitacora
```text
2026-05-10 | normal | http | 192.168.0.20 -> 192.168.0.120 | 10:00:00 - 10:10:00 | curl_wget | 20260510_normal_http_01_eve.json
```

## 13. Que sigue despues
Cuando este script quede funcionando, el siguiente paso es crear:

```bash
/home/m4rk/ppi-surikata-producto/scripts/capture/exportar_eve_por_escenario.sh
```

y luego el primer escenario real:

```bash
/home/m4rk/ppi-surikata-producto/scripts/capture/A1_http_normal.sh
```

## 14. Resumen corto
### Este script sirve para:
- registrar una corrida del laboratorio.

### Se crea en:
- `scripts/evaluation/`

### Actualiza:
- `docs/bitacora/bitacora_escenarios.txt`

### Debe ejecutarse:
- al terminar cada escenario.
