# Plan de 2 meses: escenarios necesarios para datos y flujo por fases

## 1. Proposito del documento
Este documento actualiza el enfoque del producto ingenieril desde un MVP corto hacia una implementacion seria y viable para un horizonte de dos meses. Su objetivo es definir que escenarios de trafico son necesarios para construir un dataset util, que flujo debe seguir cada fase del proyecto y como articular captura, datos, modelado, decision, enforcement y validacion de forma metodicamente solida.

## 2. Cambio de enfoque
Hasta este punto se habia trabajado con una logica de MVP inicial. A partir de ahora, el proyecto se orienta a una implementacion de mayor solidez experimental, manteniendo viabilidad dentro de un laboratorio controlado y un plazo de dos meses.

Esto implica que ya no basta con una muestra minima de trafico. Se requiere una estrategia de escenarios planificados, repetibles y documentados que produzcan:
- trafico normal representativo;
- trafico anomalo controlado;
- trafico mixto;
- suficiente volumen de `flow` para dataset;
- evidencia de comportamiento operativo para decision y control.

## 3. Objetivo tecnico del plan de 2 meses
Construir un entorno de laboratorio capaz de producir y registrar telemetria suficiente, diversa y trazable para:
1. formar un dataset base util para modelado;
2. entrenar y validar un modelo de deteccion de anomalias;
3. definir umbrales operativos de decision;
4. integrar el control inline;
5. ejecutar pruebas experimentales defendibles.

## 4. Principio de diseno de escenarios
Los escenarios no deben elegirse por complejidad extrema, sino por valor para el dataset y capacidad de repeticion. Cada escenario debe responder a una pregunta concreta:
- que aspecto del trafico normal representa?
- que patron anomalo induce?
- como se vera eso en `flow`?
- como ayudara al modelo o al control inline?

## 5. Escenarios necesarios para la data

## 5.1 Grupo A. Trafico normal de referencia
Estos escenarios son necesarios para construir la linea base del comportamiento normal del laboratorio.

### Escenario A1. Navegacion HTTP simple
**Origen:** Ubuntu Desktop `192.168.0.20`
**Destino:** Ubuntu Server `192.168.0.120`
**Servicio:** `nginx`
**Acciones:** `curl`, `wget`, acceso repetido a contenido web
**Valor para la data:** genera `flow` TCP y `app_proto` HTTP, con variabilidad en bytes y paquetes.

### Escenario A2. Administracion SSH legitima
**Origen:** Ubuntu Desktop `192.168.0.20`
**Destino:** Ubuntu Server `192.168.0.120`
**Servicio:** `openssh-server`
**Acciones:** conexiones SSH, sesiones cortas y repetidas
**Valor para la data:** aporta flujos TCP legitimos distintos al trafico HTTP.

### Escenario A3. Transferencia de archivos legitima
**Origen:** Ubuntu Desktop `192.168.0.20`
**Destino:** Ubuntu Server `192.168.0.120`
**Acciones:** `scp`, `wget` de archivos, descarga de recursos desde `nginx`
**Valor para la data:** incrementa bytes, duracion y variacion de flujo.

### Escenario A4. Trafico de servicio sostenido
**Origen:** Ubuntu Desktop `192.168.0.20`
**Destino:** Ubuntu Server `192.168.0.120`
**Acciones:** sesiones repetidas con pausas, accesos continuos durante una ventana definida
**Valor para la data:** produce comportamiento normal mas persistente y menos puntual.

### Escenario A5. Trafico de rendimiento controlado
**Origen:** Ubuntu Desktop o Kali
**Destino:** Ubuntu Server `192.168.0.120`
**Servicio:** `iperf3`
**Acciones:** sesiones controladas de transferencia
**Valor para la data:** incorpora flujos legitimos de mayor volumen.

## 5.2 Grupo B. Trafico anomalo controlado
Estos escenarios son necesarios para introducir desviaciones observables y etiquetables dentro del laboratorio.

### Escenario B1. SYN flood controlado
**Origen:** Kali `192.168.0.100`
**Destino:** Ubuntu Server `192.168.0.120`
**Accion:** `hping3 -S -p 80 --flood`
**Valor para la data:** genera anomalia clara de conexiones TCP hacia el servicio web.

### Escenario B2. Port scan TCP SYN
**Origen:** Kali `192.168.0.100`
**Destino:** Ubuntu Server o subred
**Accion:** `nmap -sS`
**Valor para la data:** representa reconocimiento, variacion de puertos y multiples intentos cortos.

### Escenario B3. UDP flood controlado
**Origen:** Kali `192.168.0.100`
**Destino:** Ubuntu Server `192.168.0.120`
**Accion:** `hping3 --udp -p 53 --flood`
**Valor para la data:** introduce patron anomalo sobre protocolo distinto a TCP.

### Escenario B4. ICMP flood controlado
**Origen:** Kali `192.168.0.100`
**Destino:** Ubuntu Server `192.168.0.120` o Ubuntu Desktop `192.168.0.20`
**Accion:** `hping3 -1 --flood`
**Valor para la data:** aporta patron de exceso de trafico simple y visible.

### Escenario B5. Acceso repetitivo anomalo al servicio
**Origen:** Kali `192.168.0.100`
**Destino:** Ubuntu Server `192.168.0.120`
**Accion:** peticiones masivas o repetitivas contra HTTP/SSH
**Valor para la data:** aproxima comportamiento abusivo sin necesidad de malware.

## 5.3 Grupo C. Trafico mixto
Estos escenarios son los mas importantes para validar un sistema de deteccion temprana con decision operativa.

### Escenario C1. HTTP legitimo + SYN flood
**Normal:** Ubuntu Desktop navega o descarga desde el servidor
**Anomalo:** Kali ejecuta `hping3 -S --flood`
**Valor:** mezcla trafico legitimo y ataque concurrente.

### Escenario C2. SSH legitimo + port scan
**Normal:** Ubuntu Desktop mantiene sesiones SSH
**Anomalo:** Kali ejecuta `nmap -sS`
**Valor:** fuerza al modelo a distinguir uso legitimo de comportamiento de reconocimiento.

### Escenario C3. Descarga legitima + UDP flood
**Normal:** transferencia o descarga activa
**Anomalo:** Kali ejecuta `hping3 --udp`
**Valor:** mezcla volumen normal con anomalia sobre otro protocolo.

## 6. Escenarios minimos obligatorios para 2 meses
Si el tiempo y recursos son limitados, estos son los escenarios minimos que no deberian faltar:

### Normales
1. HTTP legitimo
2. SSH legitimo
3. Transferencia de archivo

### Anomalos
4. SYN flood
5. Port scan
6. UDP flood

### Mixtos
7. HTTP + SYN flood
8. SSH + port scan

Con esos ocho escenarios ya puedes construir una base seria para dos meses de trabajo.

## 7. Flujo por fases con enfoque de 2 meses

## F1. Entorno e instrumentacion base
### Objetivo
Dejar las VMs, red, servicios y sensor funcionales.

### Salida
- laboratorio estable;
- Suricata funcionando;
- `eve.json` validado;
- servicios del servidor disponibles.

## F2. Generacion de trafico y captura del dataset base
### Objetivo
Ejecutar escenarios normales, anomalos y mixtos para producir telemetria cruda rica y trazable.

### Flujo
1. definir escenario;
2. registrar hora inicio/fin;
3. ejecutar trafico;
4. capturar con Suricata;
5. guardar copia de `eve.json` por ventana o corrida;
6. asociar bitacora del escenario.

### Salida
- archivos `eve.json` o recortes por escenario;
- bitacora de tiempos;
- dataset crudo util.

## F3. Parsing, etiquetado y construccion del dataset
### Objetivo
Transformar telemetria cruda en dataset tabular.

### Flujo
1. leer `eve.json`;
2. filtrar eventos `flow`;
3. extraer campos base;
4. etiquetar segun bitacora temporal del escenario;
5. consolidar CSV final;
6. limpiar nulos, duplicados y errores.

### Salida
- `dataset_raw.csv`;
- `dataset_clean.csv`;
- esquema documentado de columnas.

## F4. Feature engineering y modelado offline
### Objetivo
Generar variables derivadas y entrenar el modelo.

### Flujo
1. calcular ratios y tasas;
2. normalizar si aplica;
3. separar train/validation/test;
4. entrenar `Isolation Forest`;
5. medir score y metricas;
6. definir `t1` y `t2`.

### Salida
- features listas;
- modelo entrenado;
- umbrales iniciales.

## F5. Decision e integracion operacional
### Objetivo
Conectar score, decision y accion.

### Flujo
1. cargar modelo;
2. recibir vector de features;
3. emitir score;
4. aplicar politica `PERMIT / LIMIT / BLOCK`;
5. registrar decision;
6. preparar enforcement basico.

### Salida
- pipeline analitico-operativo funcional.

## F6. Enforcement y validacion experimental
### Objetivo
Medir comportamiento del sistema en escenarios repetidos.

### Flujo
1. ejecutar escenarios;
2. activar pipeline;
3. medir FPR, Recall, F1, latencia, impacto legitimo;
4. ajustar umbrales;
5. repetir corridas finales.

### Salida
- resultados cuantitativos;
- configuracion final del MVP;
- evidencia tecnica defendible.

## 8. Como capturar mejor la data
Para que la data sea realmente util:
- no mezclar todos los escenarios sin bitacora;
- guardar ventanas o muestras por escenario;
- registrar inicio y fin exacto de cada ataque o sesion legitima;
- mantener una nomenclatura clara por archivo.

Ejemplo de nombre de salida:

```text
20260510_normal_http_01_eve.json
20260510_anom_synflood_01_eve.json
20260510_mixto_http_syn_01_eve.json
```

## 9. Recomendacion de calendario realista para 2 meses

### Mes 1
- cerrar entorno;
- estabilizar servicios;
- ejecutar escenarios normales y anomalos;
- construir dataset crudo y parser.

### Mes 2
- feature engineering;
- entrenamiento del modelo;
- decision;
- enforcement;
- validacion y ajuste.

## 10. Conclusiones tecnicas
Para dos meses de trabajo serio, no necesitas una gran cantidad de VMs ni escenarios imposibles. Necesitas escenarios bien elegidos, repetibles y con valor para la data. La combinacion de trafico normal, anomalo y mixto sobre Ubuntu Desktop, Kali, Ubuntu Server y Suricata es suficiente para construir un dataset util, entrenar un modelo defendible y validar una arquitectura de decision y control alineada con el producto ingenieril.
