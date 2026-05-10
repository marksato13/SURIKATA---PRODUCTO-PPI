# Flujo exacto de escenarios y automatizacion de bitacora y exportacion

## 1. Proposito del documento
Este documento define el flujo exacto que debe seguir la ejecucion de escenarios del laboratorio, con especial foco en evitar confusiones de tiempo, orden y registros. Su objetivo es dejar claro como debe ejecutarse un escenario como `A1_http_normal.sh`, si conviene usar un solo script general o uno por escenario, desde que VM debe correrse y como integrar automaticamente la bitacora y la exportacion del `eve.json`.

## 2. Decisiones base recomendadas

## 2.1 Un script por escenario
La recomendacion correcta para tu proyecto es:

- **un script por escenario**

y no un unico script gigante con todos los escenarios mezclados.

### Por que
Porque cada escenario tiene:
- objetivo distinto;
- origen distinto;
- herramienta distinta;
- duracion distinta;
- valor distinto para el dataset.

Si mezclas todo en un solo `.sh`, luego se vuelve mas dificil:
- controlar tiempos;
- depurar errores;
- repetir una sola corrida;
- documentar evidencia;
- comparar resultados entre escenarios.

## 2.2 Scripts auxiliares separados
Tambien es correcto mantener separados los scripts auxiliares:
- `registrar_bitacora.sh`
- `exportar_eve_por_escenario.sh`

### Por que
Porque asi puedes reutilizarlos en todos los escenarios sin duplicar logica.

## 3. Estructura recomendada de scripts

### Scripts de captura/escenario
```bash
/home/m4rk/ppi-surikata-producto/scripts/capture/
```

Ejemplos:
- `A1_http_normal.sh`
- `A2_ssh_legitimo.sh`
- `B1_syn_flood.sh`
- `C1_http_syn_mixto.sh`

### Scripts auxiliares de evaluacion y registro
```bash
/home/m4rk/ppi-surikata-producto/scripts/evaluation/
```

Archivos:
- `registrar_bitacora.sh`
- `exportar_eve_por_escenario.sh`

## 4. Desde donde debe ejecutarse cada escenario
Cada escenario debe ejecutarse desde la VM que genera el trafico.

### Ejemplo
`A1_http_normal.sh` debe ejecutarse desde:
- Ubuntu Desktop `192.168.0.20`

Porque esa VM es la fuente del trafico legitimo.

### Regla general
- trafico normal de usuario -> desde Ubuntu Desktop
- trafico anomalo -> desde Kali
- scripts de apoyo de captura/exportacion -> desde la VM sensor o invocados remotamente

## 5. Objetivo de A1_http_normal.sh
El escenario `A1_http_normal.sh` debe servir para:
- generar trafico HTTP legitimo y repetido;
- consumir contenido del servidor `192.168.0.120`;
- producir `flow` TCP con `app_proto` HTTP;
- aportar base normal para el dataset.

No debe ser solo un `curl` aislado. Debe producir una secuencia ordenada de solicitudes durante una ventana definida.

## 6. Funcionamiento de registrar_bitacora.sh
`registrar_bitacora.sh` sirve para registrar una corrida en la bitacora.

### Que hace
Recibe estos datos:
- grupo
- escenario
- origen
- destino
- hora_inicio
- hora_fin
- herramienta
- archivo_salida

Y los escribe en:

```bash
/home/m4rk/ppi-surikata-producto/docs/bitacora/bitacora_escenarios.txt
```

### Cuando debe ejecutarse
Debe ejecutarse **al final del escenario**, cuando ya conoces:
- hora de inicio
- hora de fin
- nombre del archivo exportado

## 7. Funcionamiento de exportar_eve_por_escenario.sh
`exportar_eve_por_escenario.sh` sirve para copiar el `eve.json` actual de Suricata y guardarlo con nombre trazable por escenario.

### Que hace
Recibe:
- fecha
- grupo
- escenario
- corrida

Y genera un archivo como:

```text
20260510_normal_http_01_eve.json
```

en:

```bash
/home/m4rk/ppi-surikata-producto/data/raw/
```

### Cuando debe ejecutarse
Debe ejecutarse **al final del escenario**, antes o despues de registrar bitacora, pero siempre despues de terminada la ventana de trafico.

## 8. Flujo exacto recomendado por escenario
Este es el flujo correcto para cada corrida:

1. definir escenario;
2. guardar hora de inicio;
3. ejecutar trafico por el tiempo definido;
4. guardar hora de fin;
5. exportar `eve.json`;
6. registrar bitacora;
7. esperar si hace falta antes del siguiente escenario.

## 9. Secuencia temporal exacta de una corrida

### Ejemplo para A1_http_normal.sh
Supongamos corrida 1 del escenario HTTP normal.

#### T0
Se inicia el script.

#### T1
El script guarda:
- fecha
- hora_inicio

#### T2
El script genera trafico HTTP durante 10 minutos.

#### T3
El script guarda hora_fin.

#### T4
El script invoca `exportar_eve_por_escenario.sh` para generar:

```text
20260510_normal_http_01_eve.json
```

#### T5
El script invoca `registrar_bitacora.sh` para dejar el registro de la corrida.

#### T6
El script termina.

## 10. Recomendacion para no confundirte con los tiempos
La mejor estrategia es que **el mismo script del escenario controle el tiempo**.

No conviene que tu mires el reloj manualmente para cada corrida.

### Entonces
Cada script debe incluir internamente:
- inicio=`date +%T`
- ejecucion del trafico
- `sleep` o secuencia de duracion controlada
- fin=`date +%T`

## 11. Como automatizarlo correctamente
La automatizacion correcta no es correr `registrar_bitacora.sh` y `exportar_eve_por_escenario.sh` por separado a mano en cada prueba. Lo ideal es que **el script del escenario los llame automaticamente**.

## 12. Estructura recomendada de A1_http_normal.sh
El flujo interno del script deberia ser asi:

1. definir variables del escenario
2. guardar fecha y hora_inicio
3. ejecutar solicitudes HTTP con pausas
4. guardar hora_fin
5. llamar a `exportar_eve_por_escenario.sh`
6. llamar a `registrar_bitacora.sh`
7. mostrar mensaje de cierre

## 13. Flujo recomendado en pseudocodigo
```text
definir fecha
definir grupo=normal
definir escenario=http
definir corrida=01
guardar hora_inicio
ejecutar trafico por 10 min
guardar hora_fin
exportar eve.json
registrar bitacora
fin
```

## 14. Conclusion practica

### Lo correcto para tu proyecto es:
- un script por escenario;
- scripts auxiliares separados pero invocados automaticamente;
- el tiempo controlado dentro del escenario;
- exportacion y bitacora al final del mismo flujo.

### Entonces, para A1_http_normal.sh
Debe ejecutarse desde Ubuntu Desktop y su funcionamiento debe ser:

```text
inicia -> registra hora -> genera HTTP -> termina -> exporta eve -> registra bitacora
```

## 15. Recomendacion final
Antes de escribir todos los escenarios, construye primero un escenario completo de punta a punta con este patron:

1. `A1_http_normal.sh`
2. invocacion automatica de `exportar_eve_por_escenario.sh`
3. invocacion automatica de `registrar_bitacora.sh`

Cuando ese flujo funcione bien, replicas la misma estructura a los demas escenarios.
