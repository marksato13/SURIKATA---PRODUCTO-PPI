# Tiempos, captura y exportacion por grupos de escenarios

## 1. Proposito del documento
Este documento define el mapeo operativo de los grupos de escenarios del laboratorio: cuanto tiempo debe durar cada uno, como se debe capturar la telemetria, como separar las corridas y como exportar o guardar la salida para que luego pueda procesarse mediante scripts, parser, feature engineering y modelado.

Su objetivo es convertir los escenarios del PPI en una secuencia ejecutable y trazable, lista para ser automatizada con scripts.

## 2. Objetivo tecnico
Establecer una logica uniforme para:
- ejecutar escenarios normales, anomalos y mixtos;
- registrar tiempos exactos de inicio y fin;
- capturar `eve.json` en ventanas controladas;
- exportar muestras por escenario;
- mantener trazabilidad entre trafico generado y archivo producido.

## 3. Principio general de captura
La captura del laboratorio no debe hacerse como un unico archivo gigante sin contexto. Debe organizarse por corridas o ventanas, de modo que cada archivo exportado tenga una relacion clara con:
- tipo de escenario;
- origen;
- destino;
- herramienta usada;
- tiempo de ejecucion.

## 4. Grupos de escenarios necesarios para la data

## 4.1 Grupo A. Trafico normal
Objetivo: construir la linea base del comportamiento legitimo del laboratorio.

Escenarios recomendados:
- HTTP legitimo repetido
- SSH legitimo
- transferencia de archivos
- trafico sostenido controlado

## 4.2 Grupo B. Trafico anomalo
Objetivo: introducir patrones de desviacion controlados y reproducibles.

Escenarios recomendados:
- SYN flood controlado
- port scan
- UDP flood controlado
- ICMP flood controlado

## 4.3 Grupo C. Trafico mixto
Objetivo: combinar trafico legitimo y anomalo dentro de la misma ventana temporal para aproximar un contexto mas realista.

Escenarios recomendados:
- HTTP legitimo + SYN flood
- SSH legitimo + port scan
- descarga legitima + UDP flood

## 5. Logica de tiempos por escenario

## 5.1 Recomendacion general
No conviene usar ventanas excesivamente largas al inicio. Para una implementacion seria pero manejable, se recomienda trabajar con:
- ventanas de 5 a 15 minutos para trafico normal;
- ventanas de 1 a 5 minutos para trafico anomalo puntual;
- ventanas de 5 a 10 minutos para trafico mixto.

## 5.2 Tiempos recomendados por tipo de escenario

| Grupo | Escenario | Tiempo sugerido | Observacion |
|---|---|---|---|
| Normal | HTTP legitimo | 10 min | suficiente para generar varias sesiones |
| Normal | SSH legitimo | 5 min | sesiones cortas y repetidas |
| Normal | Transferencia de archivo | 5 min | una o varias transferencias |
| Normal | Trafico sostenido | 10 min | patron base continuo |
| Anomalo | SYN flood | 1 min | no hace falta mas para generar patron claro |
| Anomalo | Port scan | 1 a 3 min | depende del rango objetivo |
| Anomalo | UDP flood | 1 min | suficiente para anomalia visible |
| Anomalo | ICMP flood | 1 min | suficiente para observacion |
| Mixto | HTTP + SYN flood | 8 min | 5 min normal + 1 min ataque + 2 min arrastre |
| Mixto | SSH + port scan | 8 min | trafico legitimo concurrente con escaneo |
| Mixto | Descarga + UDP flood | 8 min | mezcla de volumen y anomalia |

## 6. Como debe hacerse la captura

## 6.1 Opcion recomendada
Mantener Suricata corriendo continuamente y, por cada escenario, hacer una copia del `eve.json` al finalizar la ventana definida.

Esto evita reiniciar Suricata para cada prueba y hace el laboratorio mas estable.

## 6.2 Flujo operativo por corrida
Cada corrida debe seguir este orden:
1. registrar nombre del escenario;
2. registrar hora de inicio;
3. ejecutar el trafico del escenario;
4. registrar hora de fin;
5. exportar una copia del `eve.json`;
6. renombrar la copia con convencion clara;
7. registrar el escenario en la bitacora.

## 7. Donde guardar las capturas
Usando la raiz oficial del proyecto:

```bash
/home/m4rk/ppi-surikata-producto
```

Se recomienda guardar las muestras asi:

### Telemetria cruda por escenario
```bash
/home/m4rk/ppi-surikata-producto/data/raw/
```

### Bitacora de ejecucion
```bash
/home/m4rk/ppi-surikata-producto/docs/bitacora/
```

### Resultados resumidos
```bash
/home/m4rk/ppi-surikata-producto/results/reports/
```

## 8. Convencion de nombres recomendada
Cada archivo exportado debe nombrarse de forma trazable.

Formato sugerido:

```text
YYYYMMDD_grupo_escenario_corrida_eve.json
```

Ejemplos:
- `20260510_normal_http_01_eve.json`
- `20260510_normal_ssh_02_eve.json`
- `20260510_anom_synflood_01_eve.json`
- `20260510_anom_portscan_01_eve.json`
- `20260510_mixto_http_syn_01_eve.json`

## 9. Como exportar el archivo despues de cada escenario
Si Suricata escribe en:

```bash
/var/log/suricata/eve.json
```

Entonces al terminar cada escenario puedes copiarlo asi:

```bash
cp /var/log/suricata/eve.json /home/m4rk/ppi-surikata-producto/data/raw/20260510_normal_http_01_eve.json
```

## 10. Lo ideal: registrar tiempos de cada escenario
Cada corrida deberia tener al menos esta informacion:

| Campo | Descripcion |
|---|---|
| fecha | fecha de la corrida |
| grupo | normal / anomalo / mixto |
| escenario | nombre corto del escenario |
| origen | IP o VM que genera el trafico |
| destino | IP o VM objetivo |
| hora_inicio | timestamp de inicio |
| hora_fin | timestamp de fin |
| herramienta | curl, hping3, nmap, etc. |
| observacion | nota tecnica breve |
| archivo_salida | nombre del eve exportado |

## 11. Formato sugerido de bitacora manual
Archivo sugerido:

```bash
/home/m4rk/ppi-surikata-producto/docs/bitacora/bitacora_escenarios.txt
```

Ejemplo:

```text
2026-05-10 | normal | http | 192.168.0.20 -> 192.168.0.120 | 10:00:00 - 10:10:00 | curl/wget | 20260510_normal_http_01_eve.json
2026-05-10 | anomalo | synflood | 192.168.0.100 -> 192.168.0.120 | 10:15:00 - 10:16:00 | hping3 | 20260510_anom_synflood_01_eve.json
2026-05-10 | mixto | http_syn | 192.168.0.20 + 192.168.0.100 -> 192.168.0.120 | 10:20:00 - 10:28:00 | curl + hping3 | 20260510_mixto_http_syn_01_eve.json
```

## 12. Como convertir esto en scripts despues
Este documento sirve como mapa para automatizacion futura. Cada script de escenario deberia:
1. imprimir el nombre del escenario;
2. registrar fecha y hora;
3. ejecutar los comandos de trafico;
4. esperar el tiempo definido;
5. copiar `eve.json` con nombre estandar;
6. escribir la linea correspondiente en la bitacora.

## 13. Recomendacion de ejecucion por fases

## F2 · Captura de trafico
Debes centrarte en:
- ejecutar escenarios normales;
- ejecutar escenarios anomalos;
- ejecutar escenarios mixtos;
- guardar los archivos `eve.json` por corrida.

## F3 · Parsing y dataset
Debes centrarte en:
- leer cada archivo exportado;
- filtrar eventos `flow`;
- etiquetar segun grupo y escenario;
- consolidar `dataset_raw.csv` y luego `dataset_clean.csv`.

## 14. Recomendacion de volumen inicial de data
Para una fase inicial seria, puedes plantearte:
- 3 a 4 corridas por escenario normal;
- 3 a 4 corridas por escenario anomalo;
- 3 corridas por escenario mixto.

Eso ya te da una base bastante mejor que una sola muestra por tipo.

## 15. Conclusiones tecnicas
Los tiempos, la captura y la exportacion no deben improvisarse. Deben quedar mapeados antes de automatizar los scripts de trafico. Si defines desde ahora la duracion, el nombre de salida, el grupo de escenario y la bitacora de tiempos, luego podras construir el parser y el dataset con mucha mas solidez y menos ambiguedad.
