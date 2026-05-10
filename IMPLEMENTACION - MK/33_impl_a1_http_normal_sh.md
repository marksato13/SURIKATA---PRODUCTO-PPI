# Script A1_http_normal.sh

## 1. Proposito del script
El script `A1_http_normal.sh` representa el primer escenario completo del laboratorio ejecutado de punta a punta. Su objetivo es generar trafico HTTP legitimo desde Ubuntu Desktop hacia el servidor interno, durante una ventana controlada, y al finalizar automatizar dos acciones clave:

1. exportar el `eve.json` de la corrida;
2. registrar la corrida en la bitacora del proyecto.

Este script marca el patron base que luego debera replicarse en el resto de escenarios del grupo normal, del grupo anomalo y del grupo mixto.

## 2. Objetivo tecnico del escenario
Generar una corrida controlada de trafico HTTP legitimo que:
- produzca `flow` TCP y `app_proto` HTTP en Suricata;
- sirva como parte de la linea base normal del dataset;
- quede exportada como archivo `eve.json` por corrida;
- quede documentada automaticamente en la bitacora.

## 3. Desde que VM debe ejecutarse
Este script debe ejecutarse desde:

```text
Ubuntu Desktop 192.168.0.20
```

### Justificacion
Porque Ubuntu Desktop es el origen del trafico legitimo del usuario y debe comportarse como cliente normal del laboratorio.

## 4. Relacion con el flujo completo
Este script debe seguir exactamente este patron:

```text
A1_http_normal.sh
-> genera trafico HTTP durante una ventana definida
-> llama a exportar_eve_por_escenario.sh
-> llama a registrar_bitacora.sh
```

## 5. Ruta donde debe crearse
Este script pertenece al grupo de escenarios de captura y debe ubicarse en:

```bash
/home/m4rk/ppi-surikata-producto/scripts/capture/
```

Nombre final del archivo:

```bash
/home/m4rk/ppi-surikata-producto/scripts/capture/A1_http_normal.sh
```

## 6. Carpeta donde debe crearse
Si la carpeta aun no existe, crearla con:

```bash
mkdir -p /home/m4rk/ppi-surikata-producto/scripts/capture
```

## 7. Archivo que debe existir antes de usar A1_http_normal.sh
Antes de ejecutar este escenario, ya deben existir y funcionar estos scripts auxiliares:

### Exportacion
```bash
/home/m4rk/ppi-surikata-producto/scripts/capture/exportar_eve_por_escenario.sh
```

### Bitacora
```bash
/home/m4rk/ppi-surikata-producto/scripts/evaluation/registrar_bitacora.sh
```

## 8. Comando para crear el archivo
Desde Ubuntu Desktop o desde el sistema donde prepares el contenido, el archivo puede editarse con:

```bash
nano /home/m4rk/ppi-surikata-producto/scripts/capture/A1_http_normal.sh
```

## 9. Contenido recomendado del script
Pegar este contenido:

```bash
#!/usr/bin/env bash

set -euo pipefail

FECHA="$(date +%Y%m%d)"
GRUPO="normal"
ESCENARIO="http"
CORRIDA="01"
ORIGEN="192.168.0.20"
DESTINO="192.168.0.120"
HERRAMIENTA="curl_wget"
EXPORT_SCRIPT="/home/m4rk/ppi-surikata-producto/scripts/capture/exportar_eve_por_escenario.sh"
BITACORA_SCRIPT="/home/m4rk/ppi-surikata-producto/scripts/evaluation/registrar_bitacora.sh"
ARCHIVO_SALIDA="${FECHA}_${GRUPO}_${ESCENARIO}_${CORRIDA}_eve.json"

HORA_INICIO="$(date +%T)"

END_TIME=$((SECONDS + 600))

while [ $SECONDS -lt $END_TIME ]; do
  curl -s http://${DESTINO}/ > /dev/null || true
  sleep 5
  curl -s http://${DESTINO}/info.html > /dev/null || true
  sleep 5
  wget -q -O /tmp/a1_http_test.html http://${DESTINO}/ || true
  sleep 10
done

HORA_FIN="$(date +%T)"

"$EXPORT_SCRIPT" "$FECHA" "$GRUPO" "$ESCENARIO" "$CORRIDA"
"$BITACORA_SCRIPT" "$GRUPO" "$ESCENARIO" "$ORIGEN" "$DESTINO" "$HORA_INICIO" "$HORA_FIN" "$HERRAMIENTA" "$ARCHIVO_SALIDA"

echo "Escenario A1 completado"
echo "Inicio: $HORA_INICIO"
echo "Fin: $HORA_FIN"
echo "Archivo exportado: $ARCHIVO_SALIDA"
```

## 10. Que hace este script
### Paso 1
Define variables del escenario:
- fecha
- grupo
- escenario
- corrida
- origen
- destino
- herramienta

### Paso 2
Guarda la hora de inicio.

### Paso 3
Genera trafico HTTP legitimo durante 10 minutos.

### Paso 4
Guarda la hora de fin.

### Paso 5
Invoca `exportar_eve_por_escenario.sh` para copiar el `eve.json` actual.

### Paso 6
Invoca `registrar_bitacora.sh` para dejar trazabilidad en la bitacora.

### Paso 7
Muestra un resumen final por pantalla.

## 11. Duracion del escenario
Este escenario debe durar:

```text
10 minutos
```

### Implementacion temporal
El control de tiempo se hace dentro del script mediante:

```bash
END_TIME=$((SECONDS + 600))
```

porque `600` segundos equivalen a `10` minutos.

## 12. Ejemplo real de horario
Si quieres ejecutar este escenario comenzando a las:

```text
6:30 pm
```

entonces el flujo esperado seria:

- inicio: `18:30:00`
- fin aproximado: `18:40:00`

### Resultado esperado
Al terminar, el script habra:
1. generado trafico HTTP legitimo entre `18:30` y `18:40`;
2. exportado un archivo como:

```text
20260510_normal_http_01_eve.json
```

3. escrito una linea en la bitacora con inicio y fin reales.

## 13. Permisos de ejecucion
Dar permisos con:

```bash
chmod +x /home/m4rk/ppi-surikata-producto/scripts/capture/A1_http_normal.sh
```

## 14. Ajustar propietario recomendado
Si el archivo fue creado como `root`, corregirlo con:

```bash
chown m4rk:m4rk /home/m4rk/ppi-surikata-producto/scripts/capture/A1_http_normal.sh
```

## 15. Como ejecutarlo
Ejecutar desde Ubuntu Desktop:

```bash
/home/m4rk/ppi-surikata-producto/scripts/capture/A1_http_normal.sh
```

## 16. Que debe ocurrir al terminar
El script debe dejar:

### Archivo exportado
```bash
/home/m4rk/ppi-surikata-producto/data/raw/20260510_normal_http_01_eve.json
```

### Bitacora actualizada
```bash
/home/m4rk/ppi-surikata-producto/docs/bitacora/bitacora_escenarios.txt
```

## 17. Como verificar el resultado

### Ver archivo exportado
```bash
ls -lh /home/m4rk/ppi-surikata-producto/data/raw/
```

### Ver bitacora
```bash
cat /home/m4rk/ppi-surikata-producto/docs/bitacora/bitacora_escenarios.txt
```

## 18. Observacion importante
Para que este flujo funcione bien, debes asegurarte antes de ejecutar `A1_http_normal.sh` que:
- Suricata este corriendo en la VM sensor;
- `eve.json` se este actualizando;
- el servidor `192.168.0.120` responda HTTP;
- los scripts auxiliares ya existan y sean ejecutables.

## 19. Resumen corto
### Este script sirve para:
- generar el primer escenario normal real del laboratorio.

### Se crea en:
- `scripts/capture/`

### Se ejecuta desde:
- Ubuntu Desktop `192.168.0.20`

### Dura:
- 10 minutos

### Al terminar:
- exporta `eve.json`
- registra bitacora

## 20. Conclusiones tecnicas
`A1_http_normal.sh` es el primer escenario que debe funcionar de punta a punta en el laboratorio. Si este flujo se ejecuta correctamente, ya tendras una base operativa valida para repetir el mismo patron sobre el resto de escenarios. Por eso, antes de avanzar a todo el grupo normal, este script debe quedar probado y estable.
