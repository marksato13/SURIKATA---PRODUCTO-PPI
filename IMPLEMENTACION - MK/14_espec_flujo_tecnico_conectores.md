# Especificacion detallada del flujo tecnico y conectores del MVP

## 1. Proposito del documento
Este documento describe de forma detallada el flujo tecnico del MVP del producto ingenieril, desde la generacion del trafico en laboratorio hasta la futura aplicacion de acciones de control. Su objetivo es convertir el esquema general de arquitectura en una especificacion operativa clara, identificando componentes, entradas, salidas, conectores, datos que fluyen entre modulos y puntos de validacion.

Este documento desarrolla especificamente el flujo:

```text
Cliente -> Servidor
        -> trafico observado por Sensor
Sensor -> Suricata -> EVE JSON -> Python -> Features -> Isolation Forest
       -> Score -> Decision -> iptables/ipset
```

## 2. Objetivo tecnico del flujo
Definir como se mueve la informacion a traves del MVP para que el sistema pueda:
- observar trafico de red real de laboratorio;
- convertir ese trafico en telemetria estructurada;
- transformar la telemetria en observaciones analiticas;
- calcular score de anomalia;
- traducir ese score en una decision operativa;
- preparar o ejecutar una accion sobre el trafico.

## 3. Componentes involucrados en el flujo

## 3.1 VM cliente
- IP: `192.168.0.20`
- Rol: origen del trafico
- Funcion: generar trafico normal y anomalo controlado

## 3.2 VM servidor
- IP: `192.168.0.120`
- Rol: destino del trafico
- Funcion: exponer servicios internos del laboratorio

## 3.3 VM sensor / ML / control
- IP: `192.168.0.110`
- Interfaz observada: `ens35`
- Rol: observacion, analitica, decision y base de enforcement

## 4. Flujo tecnico por capas

## 4.1 Capa 1. Generacion de trafico
### Origen
VM cliente `192.168.0.20`

### Destino
VM servidor `192.168.0.120`

### Tipos de trafico generados
- trafico normal:
  - ping;
  - HTTP con `curl` o `wget`;
  - conexiones SSH controladas;
  - transferencias simples;
- trafico anomalo:
  - `hping3`;
  - rafagas;
  - escaneo simple;
  - picos de paquetes.

### Conector de esta capa
- red de laboratorio `192.168.0.0/24`
- interfaz de la VM cliente
- interfaz de la VM servidor

### Salida de la capa
- paquetes reales en la red del laboratorio

## 4.2 Capa 2. Observacion del trafico por el sensor
### Componente
VM sensor `192.168.0.110`

### Interfaz de captura
`ens35`

### Herramienta principal
`Suricata`

### Funcion
Observar el trafico que circula en el segmento del laboratorio y producir eventos estructurados.

### Conector de esta capa
- interfaz `ens35`
- modo de observacion configurado en Suricata

### Entrada de la capa
- trafico cliente -> servidor

### Salida de la capa
- eventos `EVE JSON`
- estadisticas del motor
- alertas si las hay

## 4.3 Capa 3. Produccion de telemetria EVE JSON
### Componente
`Suricata`

### Archivo principal
```bash
/var/log/suricata/eve.json
```

### Tipos de eventos esperados
- `flow`
- `alert`
- `stats`
- otros eventos segun configuracion

### Funcion
Convertir observacion de trafico en registros estructurados consumibles por la capa analitica.

### Conector de esta capa
- archivo `eve.json`
- sistema de archivos local de la VM sensor

### Entrada de la capa
- paquetes y sesiones observadas por Suricata

### Salida de la capa
- lineas JSON independientes con telemetria de red

## 4.4 Capa 4. Ingesta desde Python
### Componente
scripts Python del proyecto

### Ruta esperada
```bash
/home/m4rk/ppi-sensor/scripts/
```

### Funcion
Leer `eve.json` o una copia controlada como `eve_inicial.json`, filtrar eventos utiles y convertirlos a estructura analitica procesable.

### Conector de esta capa
- lectura de archivo JSON desde Python
- librerias: `json`, `pandas`

### Entrada de la capa
- `eve.json` o copia en `data/raw/eve_inicial.json`

### Salida de la capa
- registros de flujo seleccionados
- estructuras en memoria para transformacion tabular

## 4.5 Capa 5. Construccion de features
### Componente
pipeline de procesamiento en Python

### Funcion
Transformar registros `flow` en variables tabulares aptas para el modelo.

### Features base esperadas
- `timestamp`
- `flow_id`
- `src_ip`
- `dest_ip`
- `src_port`
- `dest_port`
- `proto`
- `app_proto`
- `bytes_toserver`
- `bytes_toclient`
- `pkts_toserver`
- `pkts_toclient`
- `flow_duration`

### Features derivadas esperadas
- tasa de bytes;
- ratio cliente/servidor;
- promedio de bytes por paquete;
- frecuencia por IP, si aplica.

### Conector de esta capa
- DataFrame `pandas`
- script de parsing y transformacion

### Entrada de la capa
- eventos `flow` filtrados

### Salida de la capa
- dataset tabular para inferencia o entrenamiento

## 4.6 Capa 6. Modelo predictivo
### Componente
`Isolation Forest`

### Funcion
Recibir observaciones tabulares y calcular un score de anomalia por observacion.

### Conector de esta capa
- objeto modelo serializado o en memoria
- entrada numerica tabular desde `pandas` / `numpy`

### Entrada de la capa
- matriz de features del flujo

### Salida de la capa
- score de anomalia
- prediccion preliminar anomalo / no anomalo, si se define umbral

## 4.7 Capa 7. Score
### Definicion
El score representa el nivel de anomalia estimado por el modelo sobre una observacion concreta del trafico.

### Funcion
Servir como insumo directo para la capa de decision.

### Conector de esta capa
- variable numerica en memoria
- posible almacenamiento en logs o resultados del proyecto

### Entrada de la capa
- salida del modelo

### Salida de la capa
- score listo para compararse contra umbrales `t1` y `t2`

## 4.8 Capa 8. Motor de decision
### Funcion
Traducir el score a una accion operativa.

### Logica prevista
- `score < t1 -> permitir`
- `t1 <= score < t2 -> limitar`
- `score >= t2 -> bloquear`

### Conector de esta capa
- logica Python
- comparacion de score contra umbrales

### Entrada de la capa
- score de anomalia

### Salida de la capa
- veredicto operacional
- entidad objetivo de enforcement

## 4.9 Capa 9. Enforcement
### Herramientas previstas
- `iptables`
- `ipset`
- `tc` en fase posterior, si se habilita la accion `limitar`

### Funcion
Aplicar la accion operativa definida por el motor de decision sobre la entidad seleccionada, inicialmente de forma basica y controlada.

### Entidad recomendada para el MVP
- IP origen temporal

### Conector de esta capa
- reglas del kernel gestionadas desde usuario
- comandos del sistema invocados desde scripts

### Entrada de la capa
- veredicto del motor de decision
- IP o entidad objetivo

### Salida de la capa
- trafico permitido;
- trafico bloqueado;
- base para trafico limitado en una fase posterior.

## 5. Flujo end-to-end detallado

## Paso 1. El cliente genera trafico
La VM cliente inicia trafico hacia la VM servidor.

## Paso 2. El trafico circula por la red del laboratorio
El segmento `192.168.0.0/24` transporta las conexiones generadas.

## Paso 3. La VM sensor observa el trafico por `ens35`
Suricata monitorea la interfaz confirmada y analiza el trafico visible.

## Paso 4. Suricata produce eventos en `eve.json`
Cada observacion relevante se registra como evento JSON estructurado.

## Paso 5. Python consume `eve.json`
El parser toma una copia controlada o el archivo de trabajo y filtra eventos `flow`.

## Paso 6. Se construyen features
Los registros filtrados se convierten en variables base y derivadas.

## Paso 7. El modelo calcula score
`Isolation Forest` recibe el dataset y genera score por observacion.

## Paso 8. El motor de decision interpreta el score
Se compara el score con los umbrales definidos.

## Paso 9. Se genera una accion
El sistema define `permitir`, `limitar` o `bloquear`.

## Paso 10. La capa de enforcement aplica la accion
`iptables/ipset` actua sobre la entidad objetivo, segun la politica del MVP.

## 6. Conectores reales del MVP
| Capa origen | Capa destino | Conector | Tipo de intercambio |
|---|---|---|---|
| Cliente | Servidor | Red `192.168.0.0/24` | Paquetes y sesiones |
| Trafico | Suricata | Interfaz `ens35` | Observacion de red |
| Suricata | EVE JSON | `/var/log/suricata/eve.json` | Eventos JSON |
| EVE JSON | Python | Lectura de archivo | Telemetria cruda |
| Python | Features | DataFrame / estructuras en memoria | Dataset tabular |
| Features | Isolation Forest | Matriz numerica | Variables de entrada |
| Modelo | Score | Salida numerica | Riesgo de anomalia |
| Score | Decision | Umbrales `t1` y `t2` | Veredicto logico |
| Decision | iptables/ipset | Comandos / reglas | Accion operativa |

## 7. Entradas y salidas por modulo

## Modulo cliente
- Entrada: orden del escenario
- Salida: trafico normal o anomalo

## Modulo Suricata
- Entrada: trafico de red
- Salida: `eve.json`, `stats.log`, alertas

## Modulo parser
- Entrada: `eve.json`
- Salida: registros `flow` filtrados

## Modulo features
- Entrada: eventos `flow`
- Salida: dataset tabular

## Modulo modelo
- Entrada: dataset tabular
- Salida: score

## Modulo decision
- Entrada: score
- Salida: accion

## Modulo enforcement
- Entrada: accion e identidad objetivo
- Salida: regla aplicada o accion de control

## 8. Puntos de validacion del flujo
Para saber si el flujo funciona de extremo a extremo, deben validarse estos puntos:
1. existe trafico entre cliente y servidor;
2. Suricata ve trafico en `ens35`;
3. `eve.json` crece y contiene eventos;
4. existen eventos `flow`;
5. el parser extrae datos validos;
6. el dataset tabular se genera correctamente;
7. el modelo entrega score;
8. el motor traduce score a decision;
9. el enforcement puede actuar sobre la entidad objetivo.

## 9. Riesgos tecnicos del flujo

## 9.1 Trafico no visible para Suricata
Impacto:
- rompe todo el pipeline desde la capa de captura.

## 9.2 `eve.json` sin eventos `flow`
Impacto:
- no se puede construir el dataset por flujo.

## 9.3 Parser incorrecto
Impacto:
- dataset incompleto o inconsistente.

## 9.4 Score sin criterio de umbralizacion
Impacto:
- la decision no puede convertirse en accion operativa util.

## 9.5 Enforcement desacoplado de la observacion
Impacto:
- la accion no es trazable ni defendible tecnicamente.

## 10. Conclusiones tecnicas
El flujo tecnico del MVP no debe entenderse como una simple secuencia de herramientas aisladas, sino como una cadena de procesamiento en la que cada capa transforma la salida de la anterior. La fortaleza del producto ingenieril esta en esa integracion: trafico observado, telemetria estructurada, analitica reproducible, score interpretable, decision formalizada y accion operativa. Esta especificacion sirve como base para documentar, implementar y validar cada punto del flujo con trazabilidad tecnica clara.
