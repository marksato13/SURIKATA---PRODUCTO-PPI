# Actualizacion integral de escenarios, servicios y justificacion tecnica

## 1. Proposito del documento
Este documento integra las conclusiones obtenidas de las fuentes revisadas para redefinir y fortalecer los servicios del laboratorio, los escenarios de captura y la logica experimental del producto ingenieril. Su objetivo es transformar una planificacion inicial en una version metodologicamente mas solida, defendible y alineada con fuentes de referencia actuales.

Fuentes consideradas:
- ENISA Threat Landscape 2025
- Verizon DBIR 2024
- Cloudflare 2025 Q2 DDoS Threat Report
- Elastic prebuilt detection rule: potential port scanning activity
- Fortinet 2026 Global Threat Landscape Report

## 2. Criterio de actualizacion
La actualizacion no busca “complicar” el laboratorio innecesariamente, sino corregir tres puntos:
1. justificar tecnicamente por que se eligen ciertos escenarios;
2. distinguir mejor entre trafico normal, anomalo y mixto;
3. asegurar que los escenarios produzcan datos utiles para entrenamiento, ajuste de umbrales y validacion del sistema.

## 3. Principios que deben guiar el laboratorio
Las fuentes revisadas sugieren varios principios comunes:

### 3.1 El riesgo no depende solo de sofisticacion, sino de velocidad
Tanto Fortinet como ENISA subrayan que la velocidad y continuidad de la actividad maliciosa son claves. Esto refuerza la pertinencia de un sistema que detecte temprano y reaccione con baja latencia.

### 3.2 No solo importan ataques explosivos, sino patrones repetitivos y preparatorios
DBIR, Elastic y Fortinet muestran que:
- scanning;
- abuso de credenciales;
- acceso repetitivo;
- servicios expuestos;

siguen siendo elementos centrales de la amenaza moderna.

### 3.3 DDoS/DoS sigue siendo una categoria dominante y visible
ENISA y Cloudflare respaldan la inclusion de escenarios de denegacion de servicio como patrones legitimos de anomalia de red.

### 3.4 Los servicios expuestos son objetivos validos y utiles para laboratorio
DBIR y Fortinet destacan repetidamente el valor ofensivo y operativo de:
- servicios web;
- servicios de autenticacion;
- acceso remoto;
- activos de servidor.

Esto refuerza que el servidor del laboratorio con `nginx` y `ssh` es una eleccion correcta.

## 4. Actualizacion de servicios del laboratorio

## 4.1 Servicios que deben mantenerse

### Servicio HTTP con nginx
Se mantiene como servicio principal del trafico legitimo.

#### Justificacion
- DBIR resalta el valor de servicios web y aplicaciones expuestas como activos frecuentes.
- Cloudflare Radar muestra que la capa de aplicacion es una superficie relevante de abuso.
- Permite construir trafico normal reproducible y tambien escenarios de abuso repetitivo.

### Servicio SSH
Se mantiene como servicio secundario esencial.

#### Justificacion
- DBIR y Fortinet muestran que credenciales, servicios remotos y acceso a servidores siguen siendo relevantes.
- Fortinet identifica SSH como uno de los servicios bajo presion de brute force en entornos reales.
- Ayuda a generar trafico legitimo distinto de HTTP y a modelar acceso repetitivo o brute force controlado.

## 4.2 Servicio complementario opcional

### iperf3
Se mantiene solo como servicio de apoyo, no como servicio central del dataset normal.

#### Justificacion
- util para volumen controlado y enriquecimiento del dataset;
- menos representativo de usuario normal que HTTP o SSH;
- debe usarse como complemento, no como eje.

## 4.3 Servicios que no son prioritarios ahora
No se justifica, por ahora, agregar:
- DNS propio complejo solo para simular floods;
- router o DHCP como requisito para generar `flow`;
- SIEM o Big Data como nucleo;
- servicios empresariales adicionales sin impacto claro en el dataset.

## 5. Actualizacion de escenarios normales

## A1. Navegacion HTTP legitima
Se mantiene como escenario principal y obligatorio.

### Debe representar
- solicitudes repetidas;
- consulta de varias rutas;
- descarga de recursos;
- pausas controladas;
- comportamiento legitimo de usuario.

### No debe limitarse a
- un solo `curl` aislado.

## A2. SSH legitimo
Se mantiene como escenario obligatorio.

### Debe representar
- conexiones SSH cortas y repetidas;
- comandos legitimos remotos;
- uso administrativo normal.

## A3. Transferencia de archivos legitima
Se mantiene como escenario obligatorio.

### Debe representar
- `scp`;
- descargas desde `nginx`;
- archivos de tamaño variable.

## A4. Trafico sostenido
Se mantiene como escenario obligatorio.

### Debe representar
- actividad legitima persistente en ventana mayor;
- mezcla de consultas y pausas;
- comportamiento normal no puntual.

## A5. Rendimiento controlado con iperf3
Pasa a ser escenario complementario.

### Justificacion
- aporta volumen y throughput;
- pero no representa por si solo actividad de usuario comun.

## 6. Actualizacion de escenarios anomalos

## B1. SYN flood controlado
Se mantiene como escenario obligatorio.

### Justificacion
- Cloudflare lo identifica entre los vectores L3/L4 mas comunes;
- ENISA refuerza la prevalencia de DDoS/hacktivismo;
- es visible, simple y util para telemetria.

## B2. Port scan TCP SYN
Se mantiene como escenario obligatorio.

### Justificacion
- Elastic lo vincula claramente a reconocimiento (`T1046`);
- Fortinet destaca `Active Scanning` y `Nmap` como herramientas relevantes;
- es un patron temprano y valioso para deteccion de anomalia.

## B3. UDP flood controlado
Se mantiene como escenario obligatorio.

### Justificacion
- Cloudflare lo destaca como uno de los vectores principales de L3/L4;
- aporta diversidad respecto a TCP.

## B4. ICMP flood controlado
Pasa a escenario complementario.

### Justificacion
- sigue siendo un patron visible y util;
- pero tiene menos prioridad estrategica que SYN, UDP o scanning.

## B5. Acceso repetitivo anomalo
Se consolida como escenario obligatorio.

### Justificacion
- Cloudflare Radar refuerza la relevancia de seguridad en capa de aplicacion;
- permite modelar abuso de servicio sin requerir flood volumetrico;
- complementa muy bien HTTP legitimo.

## B6. Brute force controlado
Se recomienda incorporarlo como escenario complementario muy relevante.

### Justificacion
- DBIR mantiene brute force y credential attacks como via importante de acceso;
- Fortinet muestra que SSH esta entre los servicios presionados por brute force a escala.

### Recomendacion
- controlado;
- sobre SSH;
- sin desestabilizar el entorno.

## 7. Actualizacion de escenarios mixtos

## C1. HTTP legitimo + SYN flood
Se mantiene como obligatorio.

## C2. SSH legitimo + port scan
Se mantiene como obligatorio.

## C3. Descarga legitima + UDP flood
Se mantiene como obligatorio.

### Justificacion comun
Los escenarios mixtos son los mas cercanos a la utilidad real del sistema porque obligan a distinguir trafico legitimo de anomalo dentro de la misma ventana temporal.

## 8. Escenarios finales recomendados

## 8.1 Nucleo obligatorio

### Grupo normal
- A1 HTTP legitimo
- A2 SSH legitimo
- A3 Transferencia legitima
- A4 Trafico sostenido

### Grupo anomalo
- B1 SYN flood
- B2 Port scan
- B3 UDP flood
- B5 Acceso repetitivo anomalo

### Grupo mixto
- C1 HTTP + SYN flood
- C2 SSH + port scan
- C3 Descarga + UDP flood

## 8.2 Complementarios
- A5 iperf3 controlado
- B4 ICMP flood
- B6 brute force controlado

## 9. Actualizacion del flujo metodologico de la data
Con estas fuentes, el flujo de captura y datos queda mejor definido asi:

1. ejecutar escenarios normales para construir linea base;
2. ejecutar escenarios anomalos de red y servicio;
3. ejecutar escenarios mixtos para validar convivencia;
4. exportar `eve.json` por corrida;
5. registrar bitacora temporal;
6. filtrar `flow` en el parser;
7. etiquetar segun grupo y ventana temporal;
8. construir dataset y features.

## 10. Cosas que debes evitar
Con las fuentes revisadas, conviene evitar estas debilidades de diseño:

- usar solo un tipo de ataque anomalo;
- depender solo de floods y olvidar reconocimiento o abuso de servicio;
- mezclar todos los escenarios sin bitacora ni exportacion por corrida;
- afirmar que el laboratorio replica volumen real de Internet;
- tratar todos los servicios con el mismo peso cuando `HTTP` y `SSH` son los mas utiles para tu entorno.

## 11. Formula defendible para la tesis
La mejor forma de defender el diseño actualizado seria algo asi:

> Los escenarios del laboratorio se definieron con base en patrones de amenaza observados en reportes recientes de inteligencia y respuesta, priorizando formas prevalentes y operativamente relevantes de denegacion de servicio, reconocimiento de red, abuso de servicios expuestos y trafico legitimo de referencia. La seleccion no busca reproducir el volumen total de campañas reales, sino modelar comportamientos suficientemente representativos y trazables para evaluar la deteccion temprana y la respuesta operativa del sistema propuesto.

## 12. Conclusiones tecnicas
Las fuentes revisadas muestran que el laboratorio debe ir mas alla de floods simples y apoyarse en una combinacion balanceada de trafico legitimo, reconocimiento, abuso repetitivo de servicio y denegacion de servicio controlada. Con esta actualizacion, los servicios del entorno, los escenarios y el flujo de datos quedan mucho mejor alineados con el producto ingenieril y con un objetivo de entrenamiento y validacion mas serio para el modelo.
