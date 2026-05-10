# Flujo de scripts, orden de ejecucion y plan operativo del laboratorio

## 1. Proposito del documento
Este documento consolida la planificacion operativa del laboratorio antes de la ejecucion real de los escenarios. Su objetivo es dejar claro como funcionara el flujo completo de captura, que hace cada script, en que orden debe ejecutarse y como se relaciona cada pieza con las fases del producto ingenieril.

## 2. Objetivo tecnico
Definir un flujo repetible y trazable para:
- ejecutar escenarios normales, anomalos y mixtos;
- capturar telemetria con Suricata;
- exportar `eve.json` por corrida;
- registrar bitacora;
- preparar la data para parsing y modelado.

## 3. Idea general del flujo
El laboratorio debe operar bajo esta logica:

```text
1. Preparar el escenario
2. Ejecutar trafico
3. Suricata captura
4. Exportar eve.json de la corrida
5. Registrar bitacora
6. Repetir escenario
7. Parsear los archivos exportados
8. Construir dataset
9. Entrenar modelo
```

## 4. Flujo logico completo

## Etapa 1. Definicion del escenario
Primero se define que escenario se ejecutara:
- normal;
- anomalo;
- mixto.

Ejemplos:
- `A1_http_normal`
- `B1_syn_flood`
- `C1_http_syn_mixto`

## Etapa 2. Ejecucion del trafico
Se ejecuta el script del escenario. Ese script debe:
- lanzar trafico desde la VM correcta;
- usar el tiempo definido;
- aplicar comandos controlados;
- dejar una ventana clara de actividad.

## Etapa 3. Captura por Suricata
Mientras el escenario corre:
- Suricata debe estar activo en `192.168.0.110`;
- debe observar el trafico en `ens35`;
- debe escribir telemetria en `eve.json`.

En esta etapa, si Suricata ya esta bien validado, no deberia requerirse accion manual adicional.

## Etapa 4. Exportacion del eve.json
Al finalizar la corrida:
- se hace una copia de `eve.json`;
- se guarda con nombre trazable y estandarizado.

Ejemplo:

```text
20260510_normal_http_01_eve.json
```

Esta tarea debe realizarla un script auxiliar de exportacion.

## Etapa 5. Registro de bitacora
Despues de exportar el archivo, debe registrarse:
- fecha;
- hora de inicio;
- hora de fin;
- grupo;
- escenario;
- origen;
- destino;
- herramienta usada;
- archivo de salida generado.

Esto tambien debe realizarlo un script auxiliar o una funcion reutilizable.

## Etapa 6. Repeticion del escenario
Cada escenario debe repetirse segun el numero de corridas planeado:
- corrida 1;
- corrida 2;
- corrida 3.

Luego se pasa al siguiente escenario del plan.

## Etapa 7. Parsing posterior
Cuando ya existan suficientes archivos exportados:
- se ejecuta `parse_eve_to_csv.py`;
- se filtran eventos `flow`;
- se construye el dataset tabular.

## 5. Scripts necesarios y funcion de cada uno

## 5.1 registrar_bitacora.sh
### Funcion
Guardar una linea por cada corrida en la bitacora del laboratorio.

### Datos que debe registrar
- grupo;
- escenario;
- origen;
- destino;
- hora de inicio;
- hora de fin;
- herramienta;
- archivo de salida.

### Cuandose ejecuta
Despues de cada escenario o al final del script del escenario.

### Salida esperada
Archivo tipo:

```bash
docs/bitacora/bitacora_escenarios.txt
```

## 5.2 exportar_eve_por_escenario.sh
### Funcion
Copiar el `eve.json` actual y guardarlo con nombre estandar por escenario.

### Datos que debe recibir
- fecha;
- grupo;
- escenario;
- numero de corrida.

### Cuandose ejecuta
Al terminar cada corrida.

### Salida esperada
Archivo en:

```bash
data/raw/
```

Ejemplo:

```text
20260510_normal_http_01_eve.json
```

## 5.3 A1_http_normal.sh
### Funcion
Generar trafico HTTP legitimo desde Ubuntu Desktop hacia el servidor.

### Que hace
- solicitudes `curl`;
- descargas `wget`;
- pausas entre solicitudes;
- duracion definida.

### Cuandose ejecuta
Cuando se trabaja el grupo normal, escenario A1.

### Salida funcional
- trafico HTTP legitimo;
- mas eventos `flow`;
- telemetria util para linea base.

## 5.4 A2_ssh_legitimo.sh
### Funcion
Generar sesiones SSH legitimas entre el cliente y el servidor.

### Que hace
- conexiones SSH;
- sesiones cortas repetidas;
- comandos basicos remotos.

### Cuandose ejecuta
En el grupo normal, escenario A2.

## 5.5 A3_transferencia_archivos.sh
### Funcion
Generar trafico legitimo de transferencia.

### Que hace
- `scp`;
- descarga de archivos;
- transferencias por HTTP o SSH.

### Cuandose ejecuta
En el grupo normal, escenario A3.

## 5.6 B1_syn_flood.sh
### Funcion
Generar un SYN flood controlado desde Kali hacia el servidor.

### Que hace
- `hping3 -S -p 80 --flood`;
- durante una ventana definida;
- hacia `192.168.0.120`.

### Cuandose ejecuta
En el grupo anomalo, escenario B1.

## 5.7 B2_port_scan.sh
### Funcion
Generar un escaneo TCP SYN sobre el servidor o la subred.

### Que hace
- `nmap -sS`;
- reconocimiento controlado.

### Cuandose ejecuta
En el grupo anomalo, escenario B2.

## 5.8 B3_udp_flood.sh
### Funcion
Generar trafico UDP anomalo controlado.

### Que hace
- `hping3 --udp -p 53 --flood`;
- contra el servidor.

### Cuandose ejecuta
En el grupo anomalo, escenario B3.

## 5.9 C1_http_syn_mixto.sh
### Funcion
Combinar trafico legitimo HTTP con ataque SYN concurrente.

### Que hace
- primero genera trafico normal HTTP;
- luego superpone `hping3 -S --flood`;
- luego deja una ventana de continuidad.

### Cuandose ejecuta
En el grupo mixto, escenario C1.

## 6. Orden real de ejecucion

## Paso 1
Confirmar que Suricata esta corriendo y que `eve.json` esta disponible.

## Paso 2
Ejecutar un escenario, por ejemplo:
- `A1_http_normal.sh`

## Paso 3
Cuando termina el escenario:
- correr `exportar_eve_por_escenario.sh`;
- correr `registrar_bitacora.sh`.

## Paso 4
Repetir la corrida segun el numero planificado.

## Paso 5
Pasar al siguiente escenario del grupo correspondiente.

## 7. Ejemplo practico de una corrida

## Escenario A1
1. Se inicia `A1_http_normal.sh`
2. El escenario dura 10 minutos
3. Termina la ejecucion
4. Se exporta:

```text
20260510_normal_http_01_eve.json
```

5. Se registra en la bitacora:

```text
2026-05-10 | normal | http | 192.168.0.20 -> 192.168.0.120 | 10:00 - 10:10 | curl/wget | 20260510_normal_http_01_eve.json
```

6. Se repite la corrida segun corresponda.

## 8. Relacion con las fases del proyecto

## F1
Entorno listo y Suricata validado.

## F2
Aqui se ejecutan principalmente:
- los scripts de trafico normal;
- los scripts de trafico anomalo;
- los scripts de trafico mixto;
- `exportar_eve_por_escenario.sh`;
- `registrar_bitacora.sh`.

## F3
Aqui se ejecutan:
- parser;
- limpieza;
- features;
- construccion del dataset.

## 9. Lo que no debe pasar
No debes:
- correr varios escenarios sin exportar el `eve.json`;
- mezclar capturas sin bitacora;
- olvidar registrar inicio y fin;
- no distinguir entre corrida 1, 2 y 3.

## 10. Nucleo minimo recomendado antes de automatizar todo
Antes de construir todos los scripts, se recomienda asegurar primero este nucleo:
1. `registrar_bitacora.sh`
2. `exportar_eve_por_escenario.sh`
3. `A1_http_normal.sh`
4. `B1_syn_flood.sh`
5. `C1_http_syn_mixto.sh`

Con esos cinco se entiende y valida todo el flujo del laboratorio. Despues se replica el patron al resto de escenarios.

## 11. Conclusiones tecnicas
El valor de este plan no esta solo en definir escenarios, sino en establecer un flujo de ejecucion reproducible. Cada script debe tener una funcion clara, un momento especifico de ejecucion y una salida verificable. Si se sigue este orden, la captura del laboratorio sera mucho mas util para parser, modelado y decision, y el proyecto avanzara con trazabilidad y control experimental reales.
