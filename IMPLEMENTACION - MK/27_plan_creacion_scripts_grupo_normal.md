# Planificacion de la etapa de scripts: inicio por el grupo normal

## 1. Proposito del documento
Este documento planifica el inicio de la etapa de ejecucion real del laboratorio a traves de scripts. Su objetivo es definir el orden de creacion de scripts por escenario, comenzando por el grupo de trafico normal, y detallar cada escenario de ese grupo para que la implementacion posterior sea ordenada, repetible y consistente con la metodologia del producto ingenieril.

## 2. Objetivo de esta etapa
Pasar de la planificacion general del laboratorio a la construccion real de scripts ejecutables, comenzando por los escenarios normales que serviran como base del dataset de entrenamiento del modelo.

## 3. Principio de avance
No se deben crear todos los scripts a la vez. La estrategia correcta es:
1. definir el grupo de escenarios a automatizar;
2. priorizar los escenarios de mayor valor para la data;
3. crear los scripts en orden logico;
4. validar uno por uno que generan trafico, registran bitacora y exportan `eve.json`.

## 4. Etapa 1. Escenario
En esta etapa, primero se decide que grupo de escenarios se desarrollara.

Las categorias principales ya definidas son:
- normal
- anomalo
- mixto

Ejemplos de nombre de escenario:
- `A1_http_normal`
- `B1_syn_flood`
- `C1_http_syn_mixto`

## 5. Decision de arranque
Se comenzara por el grupo normal.

### Justificacion tecnica
Esto es lo mas correcto porque:
1. el modelo `Isolation Forest` necesita primero una base de comportamiento legitimo;
2. el dataset normal es el punto de partida del entrenamiento;
3. permite validar el servidor, el cliente, Suricata y la exportacion de telemetria sin introducir aun ruido de ataque;
4. ayuda a detectar fallos de captura o parser antes de mezclar trafico anomalo.

## 6. Orden de creacion de scripts del grupo normal
El orden recomendado para construir los scripts del grupo normal es el siguiente:

1. `A1_http_normal.sh`
2. `A2_ssh_legitimo.sh`
3. `A3_transferencia_archivos.sh`
4. `A4_trafico_sostenido.sh`
5. `A5_iperf3_controlado.sh` (opcional)

## 7. Detalle de cada escenario del grupo normal

## 7.1 Escenario A1. HTTP legitimo
### Nombre del script
```bash
A1_http_normal.sh
```

### Objetivo del escenario
Generar trafico HTTP legitimo y repetido desde Ubuntu Desktop hacia el servidor para producir sesiones web observables en Suricata y construir parte de la linea base del dataset normal.

### Origen
- Ubuntu Desktop `192.168.0.20`

### Destino
- Ubuntu Server `192.168.0.120`

### Servicio involucrado
- `nginx`

### Acciones esperadas del script
- ejecutar solicitudes `curl` repetidas;
- descargar recursos con `wget`;
- alternar varias rutas del servicio web;
- introducir pausas entre solicitudes para evitar un patron totalmente artificial.

### Valor para la data
- genera `flow` TCP y `app_proto` HTTP;
- aporta variabilidad en bytes y paquetes;
- permite observar trafico legitimo simple y reproducible.

### Duracion sugerida por corrida
- 10 minutos

### Repeticiones recomendadas
- 3 corridas

### Resultado esperado
- varios `flow` HTTP legitimos;
- archivo exportado por corrida;
- entrada en la bitacora.

## 7.2 Escenario A2. SSH legitimo
### Nombre del script
```bash
A2_ssh_legitimo.sh
```

### Objetivo del escenario
Generar sesiones SSH legitimas y repetidas entre el cliente y el servidor para complementar la linea base normal con trafico administrativo realista.

### Origen
- Ubuntu Desktop `192.168.0.20`

### Destino
- Ubuntu Server `192.168.0.120`

### Servicio involucrado
- `openssh-server`

### Acciones esperadas del script
- abrir sesiones SSH cortas;
- ejecutar comandos basicos remotos;
- cerrar y reabrir sesiones;
- mantener una o dos sesiones algo mas largas para variabilidad.

### Valor para la data
- aporta flujos TCP legitimos distintos de HTTP;
- incrementa diversidad de comportamiento normal;
- ayuda a representar actividad administrativa legitima.

### Duracion sugerida por corrida
- 5 a 8 minutos

### Repeticiones recomendadas
- 3 corridas

### Resultado esperado
- flujos SSH legitimos y trazables;
- exportacion por corrida;
- registro en bitacora.

## 7.3 Escenario A3. Transferencia de archivos legitima
### Nombre del script
```bash
A3_transferencia_archivos.sh
```

### Objetivo del escenario
Generar trafico legitimo de transferencia de archivos para enriquecer el dataset con flujos de mayor volumen, mas bytes y mayor duracion.

### Origen
- Ubuntu Desktop `192.168.0.20`

### Destino
- Ubuntu Server `192.168.0.120`

### Servicios involucrados
- `scp`
- `nginx`

### Acciones esperadas del script
- copiar archivos mediante `scp`;
- descargar archivos desde `nginx` con `wget`;
- combinar archivos pequenos y medianos para variar los flujos.

### Valor para la data
- incrementa bytes transferidos;
- produce flujos mas largos;
- mejora variedad del trafico legitimo para modelado.

### Duracion sugerida por corrida
- 8 a 10 minutos

### Repeticiones recomendadas
- 3 corridas

### Resultado esperado
- flujos con mayor volumen y duracion;
- telemetria util para features como tasa y ratios;
- archivo exportado por corrida.

## 7.4 Escenario A4. Trafico de servicio sostenido
### Nombre del script
```bash
A4_trafico_sostenido.sh
```

### Objetivo del escenario
Generar un patron normal mas persistente y menos puntual, para que el modelo no solo aprenda eventos cortos, sino tambien actividad estable y repetida en el tiempo.

### Origen
- Ubuntu Desktop `192.168.0.20`

### Destino
- Ubuntu Server `192.168.0.120`

### Acciones esperadas del script
- solicitudes repetidas durante una ventana mas larga;
- combinacion de HTTP, ping y acceso al servidor;
- pausas y reanudaciones controladas dentro de la misma corrida.

### Valor para la data
- mejora representacion del comportamiento normal sostenido;
- da contexto temporal al dataset;
- evita que todo el trafico legitimo parezca demasiado puntual.

### Duracion sugerida por corrida
- 15 minutos

### Repeticiones recomendadas
- 3 corridas

### Resultado esperado
- patrones normales persistentes;
- mas variedad temporal en `flow`;
- mejor base para el entrenamiento del modelo.

## 7.5 Escenario A5. Rendimiento controlado
### Nombre del script
```bash
A5_iperf3_controlado.sh
```

### Objetivo del escenario
Agregar opcionalmente un escenario de transferencia controlada de mayor volumen para complementar la linea base normal.

### Origen
- Ubuntu Desktop `192.168.0.20`
o
- Kali `192.168.0.100`

### Destino
- Ubuntu Server `192.168.0.120`

### Servicio involucrado
- `iperf3`

### Acciones esperadas del script
- iniciar sesion `iperf3` cliente-servidor;
- mantener una transferencia controlada por una ventana breve.

### Valor para la data
- incorpora flujos legitimos de mayor volumen;
- ayuda a ampliar variacion de bytes y throughput.

### Duracion sugerida por corrida
- 5 minutos

### Repeticiones recomendadas
- 2 o 3 corridas

### Estado metodologico
- opcional

## 8. Scripts auxiliares que deben existir antes o junto al grupo normal
Antes de automatizar plenamente el grupo normal, conviene tener definidos o crear en paralelo estos scripts auxiliares:

1. `registrar_bitacora.sh`
2. `exportar_eve_por_escenario.sh`

### Por que
Porque cada script normal debe terminar dejando:
- un archivo `eve.json` exportado;
- una entrada de bitacora.

## 9. Orden practico de construccion
El orden recomendado de construccion y validacion es:

1. `registrar_bitacora.sh`
2. `exportar_eve_por_escenario.sh`
3. `A1_http_normal.sh`
4. validar A1
5. `A2_ssh_legitimo.sh`
6. validar A2
7. `A3_transferencia_archivos.sh`
8. validar A3
9. `A4_trafico_sostenido.sh`
10. validar A4
11. `A5_iperf3_controlado.sh` si se decide usar

## 10. Regla de validacion por script
Cada script del grupo normal se considera correcto si al ejecutarlo produce:
1. trafico real sobre la red del laboratorio;
2. evidencia observable en Suricata;
3. una exportacion `eve.json` con nombre correcto;
4. una linea de bitacora.

## 11. Lo que no debe hacerse
No conviene:
- crear todos los scripts sin probar uno primero;
- pasar al grupo anomalo sin validar al menos A1 y A2;
- generar trafico normal sin exportar ni registrar la corrida.

## 12. Conclusiones tecnicas
El grupo normal debe ser el primer bloque de automatizacion del laboratorio porque constituye la base del dataset que alimentara el entrenamiento del modelo. Empezar por HTTP, SSH, transferencia y trafico sostenido permite construir una linea base legitima, trazable y suficientemente rica antes de introducir escenarios anómalos o mixtos. Esta etapa marca el comienzo real de la ejecucion controlada del producto ingenieril.
