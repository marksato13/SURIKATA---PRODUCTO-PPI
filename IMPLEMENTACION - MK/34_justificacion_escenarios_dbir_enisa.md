# Justificacion de escenarios del laboratorio con base en ENISA 2025 y DBIR 2024

## 1. Proposito del documento
Este documento integra y traduce en criterios tecnicos de laboratorio los hallazgos mas relevantes de dos fuentes de referencia para el PPI:
- ENISA Threat Landscape 2025
- Verizon 2024 Data Breach Investigations Report (DBIR)

Su objetivo es justificar de manera metodologica y tecnica por que los escenarios seleccionados para el laboratorio —DoS/DDoS, escaneo, acceso repetitivo y fuerza bruta controlada— son pertinentes para la construccion del dataset, el entrenamiento del modelo y la validacion del producto ingenieril.

## 2. Criterio general de uso de las fuentes
Ninguno de los informes se usa para afirmar que el laboratorio replica exactamente el comportamiento de actores reales. Su funcion en el PPI es otra:
- sustentar la seleccion de patrones de trafico anomalo relevantes;
- justificar que esos patrones siguen siendo prevalentes y operativamente significativos;
- demostrar que los escenarios del laboratorio son coherentes con amenazas contemporaneas observadas en entornos reales.

En ese sentido, el laboratorio no busca imitar grupos concretos, sino reproducir patrones de red y modos de comportamiento suficientemente representativos para probar deteccion temprana y control operativo.

## 3. Hallazgos clave tomados de ENISA 2025

## 3.1 Predominio de DDoS y hacktivismo
ENISA 2025 indica que:
- los ataques DDoS representaron aproximadamente el 76.7% de los incidentes registrados en su dataset general;
- la actividad hacktivista represento casi el 80% de los incidentes reportados;
- la mayoria de esas operaciones se basaron en ataques DDoS de bajo costo y baja complejidad relativa;
- aunque muchas campañas producen bajo impacto individual, su volumen y continuidad las vuelven relevantes desde la perspectiva de resiliencia y monitorizacion.

### Implicacion para el PPI
Esto justifica incluir en el laboratorio patrones de denegacion de servicio controlada como:
- SYN flood
- UDP flood
- ICMP flood

No porque el laboratorio pretenda reproducir a un actor concreto, sino porque estos patrones siguen siendo una forma prevalente y operativamente visible de trafico anomalo.

## 3.2 Escaneo y reconocimiento como precursor observable
ENISA resalta la observacion recurrente de TTPs de reconocimiento y descubrimiento, incluyendo:
- `T1595 Active Scanning`
- `T1046 Network Service Discovery`
- `T1016 System Network Configuration Discovery`

### Implicacion para el PPI
Esto justifica incorporar escenarios de reconocimiento y escaneo como:
- `nmap -sS` sobre el servidor
- `nmap -sS` sobre la subred del laboratorio

porque representan un patron temprano, visible en flujo, que es tecnicamente pertinente para deteccion de comportamiento anomalo.

## 3.3 Relevancia de protecciones de red y monitorizacion
ENISA enfatiza controles como:
- `Network Intrusion Prevention`
- `Filter Network Traffic`
- `Network Segmentation`
- `Monitoring`
- `Resilience`

### Implicacion para el PPI
Esto refuerza la coherencia de la arquitectura propuesta:
- Suricata como sensor;
- parser y modelo como capa analitica;
- decision y `iptables/ipset` como capa operativa de respuesta.

En otras palabras, la propuesta del PPI encaja con una vision de defensa basada en monitorizacion, proteccion de red y resiliencia operativa.

## 4. Hallazgos clave tomados de DBIR 2024

## 4.1 DoS como patron dominante en incidentes
DBIR 2024 indica que:
- DoS fue el patron mas frecuente en incidentes;
- estuvo presente en alrededor del 59% de los incidentes registrados;
- los ataques de denegacion de servicio siguen siendo ubicuos y de ejecucion relativamente barata;
- la recomendacion general es que las organizaciones se preparen para su ocurrencia y cuenten con mitigacion o capacidad de respuesta.

### Implicacion para el PPI
Esto da sustento adicional a que el laboratorio incluya escenarios de denegacion de servicio como una categoria central del dataset anomalo.

## 4.2 Ataques de fuerza bruta y abuso de credenciales
DBIR 2024 destaca en Basic Web Application Attacks y resultados asociados:
- uso de credenciales robadas como via de acceso dominante;
- presencia de `Brute force` como tecnica clasica y todavia vigente;
- necesidad de controles de autenticacion, MFA y limitacion de intentos.

### Implicacion para el PPI
Esto permite justificar un escenario de:
- acceso repetitivo anomalo al servicio

y, en una version controlada, un escenario de:
- intentos repetidos de acceso tipo brute force o password spraying controlado sobre SSH o servicios de aplicacion del laboratorio.

No se recomienda un ataque agresivo e ilimitado, sino una simulacion controlada de multiples intentos de acceso con valor para el flujo y el dataset.

## 4.3 Activos mas atacados: servidores y aplicaciones expuestas
DBIR resalta que los `Server` assets y las `Web applications` son objetivos frecuentes.

### Implicacion para el PPI
Esto refuerza que el servidor `192.168.0.120`, con `nginx` y `ssh`, es un blanco razonable para:
- trafico legitimo;
- reconocimiento;
- abuso de servicio;
- patrones de acceso repetitivo;
- denegacion de servicio controlada.

## 5. Escenarios del laboratorio y su justificacion

## 5.1 Escenarios normales

### A1. Navegacion HTTP legitima
**Justificacion:**
- los servidores web son activos frecuentes y utiles en telemetria de red;
- la interaccion con aplicaciones web forma parte del trafico legitimo esperado;
- permite producir `flow` TCP con `app_proto` HTTP y variabilidad controlada.

### A2. SSH legitimo
**Justificacion:**
- el acceso remoto es un patron operativo real y aparece como servicio relevante en activos de servidor;
- produce trafico legitimo distinto al HTTP y aporta diversidad al dataset normal.

### A3. Transferencia de archivos legitima
**Justificacion:**
- incrementa volumen, duracion y variacion de bytes;
- representa uso legitimo de servicios del servidor.

### A4. Trafico sostenido
**Justificacion:**
- ayuda a evitar que la linea base normal quede reducida a eventos puntuales o demasiado breves;
- mejora la estabilidad temporal del dataset de entrenamiento.

## 5.2 Escenarios anomalos

### B1. SYN flood controlado
**Justificacion:**
- alineado con ENISA 2025 y DBIR 2024 sobre prevalencia de DoS/DDoS;
- genera un patron claro de trafico anomalo sobre TCP.

### B2. Port scan TCP SYN
**Justificacion:**
- alineado con TTPs de reconocimiento y `Active Scanning` descritos por ENISA y DBIR;
- permite observar desviaciones tempranas y cambios en distribucion de puertos y sesiones.

### B3. UDP flood controlado
**Justificacion:**
- representa una forma distinta de DoS, sobre protocolo diferente a TCP;
- aporta diversidad de anomalia al dataset.

### B4. ICMP flood controlado
**Justificacion:**
- aunque menos prioritario que TCP y UDP, sigue siendo un patron simple y visible de denegacion de servicio;
- puede utilizarse como escenario complementario.

### B5. Acceso repetitivo anomalo al servicio
**Justificacion:**
- alineado con DBIR en cuanto a abuso de credenciales, intentos repetidos y ataques basicos sobre servicios expuestos;
- es util para representar una anomalia menos explosiva que un flood, pero mas cercana al comportamiento persistente y abusivo.

### B6. Brute force controlado sobre servicio expuesto (opcional pero justificable)
**Justificacion:**
- DBIR mantiene el brute force como tecnica clasica y aun vigente;
- puede aportar un patron anomalo distinto a flooding y scanning;
- debe ejecutarse con limites claros de intentos y tiempo para no desestabilizar el entorno.

## 5.3 Escenarios mixtos

### C1. HTTP legitimo + SYN flood
**Justificacion:**
- representa coexistencia entre trafico normal y anomalo;
- es clave para evaluar deteccion temprana con interferencia legitima.

### C2. SSH legitimo + port scan
**Justificacion:**
- fuerza al sistema a distinguir administracion legitima de reconocimiento de servicios.

### C3. Descarga legitima + UDP flood
**Justificacion:**
- mezcla volumen normal con anomalia de otro protocolo;
- aporta mayor diversidad para el dataset mixto.

## 6. Que escenarios son obligatorios y cuales complementarios

## Obligatorios
- A1 HTTP legitimo
- A2 SSH legitimo
- A3 transferencia legitima
- A4 trafico sostenido
- B1 SYN flood
- B2 port scan
- B3 UDP flood
- B5 acceso repetitivo anomalo
- C1 HTTP + SYN flood
- C2 SSH + port scan
- C3 descarga + UDP flood

## Complementarios
- A5 iperf3 controlado
- B4 ICMP flood
- B6 brute force controlado

## 7. Conclusiones tecnicas
La combinacion de ENISA 2025 y DBIR 2024 sustenta de forma suficiente la seleccion de escenarios del laboratorio. ENISA justifica con claridad la inclusion de DoS/DDoS, scanning y monitorizacion de red como amenazas prevalentes y operativamente relevantes. DBIR 2024 aporta sustento adicional para considerar la ubicuidad del DoS, la relevancia del brute force, el abuso de credenciales y la importancia de servicios expuestos y activos de servidor. En conjunto, ambos informes apoyan una planificacion de laboratorio basada en patrones anomalo-legitimos claros, defendibles y utiles para capturar telemetria, construir dataset y entrenar el modelo del producto ingenieril.
