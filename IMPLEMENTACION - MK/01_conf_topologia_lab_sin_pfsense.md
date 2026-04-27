# Topologia inicial de laboratorio sin pfSense

## 1. Proposito del documento
Este documento define la topologia inicial recomendada para la primera etapa de implementacion del producto PPI, priorizando simplicidad, viabilidad tecnica y bajo consumo de recursos. La propuesta excluye deliberadamente el uso de `pfSense` en esta fase inicial, con el fin de concentrar el esfuerzo en el nucleo real del proyecto: captura de telemetria, modelado predictivo, motor de decision y enforcement basico en laboratorio.

Esta arquitectura esta pensada para un escenario unico, controlado y migrable posteriormente a un hipervisor de mayor capacidad.

## 2. Decision de arquitectura
Para esta primera etapa no se considera necesario incorporar una VM adicional con `pfSense` o `OPNsense`, por las siguientes razones:
- no aporta novedad al producto central del PPI;
- incrementa complejidad operativa sin mejorar el MVP inmediato;
- consume recursos de CPU, RAM y administracion que conviene reservar para el entorno del producto;
- el objetivo actual es validar el flujo minimo funcional del sistema, no construir un laboratorio empresarial completo.

Por ello, la arquitectura inicial se construye con tres maquinas virtuales conectadas en una red de laboratorio controlada.

## 3. Objetivo tecnico del escenario
Construir un entorno minimo funcional que permita:
- generar trafico normal y anomalo;
- capturar telemetria de red con Suricata;
- procesar eventos EVE JSON;
- entrenar y ejecutar el modelo predictivo;
- aplicar decisiones basicas de control sobre el trafico;
- medir comportamiento preliminar del MVP.

## 4. Topologia recomendada

```text
                 HOST / HIPERVISOR
                        |
                vSwitch / LAN interna
        --------------------------------------
        |                 |                  |
        |                 |                  |
   [VM1 - SENSOR]    [VM2 - CLIENTE]    [VM3 - SERVIDOR]
   Suricata          trafico normal      servicios objetivo
   Python            trafico anomalo     web / ssh / prueba
   ML + decision     hping3 / curl       destino del flujo
   enforcement
```

## 5. Descripcion de las maquinas virtuales

## 5.1 VM1 - Sensor, analitica y control
### Funcion principal
Esta maquina es el nucleo del producto PPI. Sobre ella se implementa la parte diferencial del sistema.

### Responsabilidades
- capturar trafico o recibir telemetria del entorno de laboratorio;
- ejecutar `Suricata` y generar eventos en formato `EVE JSON`;
- procesar la telemetria con `Python`;
- construir features para el modelo;
- ejecutar `Isolation Forest`;
- transformar score en decision operativa;
- aplicar enforcement basico mediante `iptables/ipset`;
- registrar resultados y evidencias del sistema.

### Software sugerido
- Ubuntu Server o Debian
- Suricata
- Python
- pandas
- numpy
- scikit-learn
- iptables
- ipset
- tc (opcional en etapa posterior)

### Recursos recomendados
- vCPU: 4
- RAM: 8 GB
- Disco: 60 GB a 80 GB
- Interfaces virtuales: 1 como minimo

### Observacion tecnica
Esta VM debe ser la prioridad principal de recursos del escenario. Si el host es limitado, es preferible recortar recursos de otras VMs antes que debilitar esta.

## 5.2 VM2 - Cliente generador de trafico
### Funcion principal
Simular el origen del trafico del laboratorio, tanto en condiciones normales como anomalas.

### Responsabilidades
- generar trafico legitimo de referencia;
- producir trafico anomalo simple para pruebas controladas;
- actuar como origen de conexiones hacia la VM servidor;
- servir como base para escenarios de navegacion, ping, descarga, rafagas o escaneo basico.

### Software sugerido
- Ubuntu Server o Debian
- curl
- wget
- ping
- hping3
- iperf3 (opcional)
- nmap (opcional y solo para laboratorio)

### Recursos recomendados
- vCPU: 2
- RAM: 2 GB
- Disco: 20 GB
- Interfaces virtuales: 1

### Observacion tecnica
Esta VM no necesita gran capacidad. Su valor esta en permitir reproducir escenarios controlados y documentables.

## 5.3 VM3 - Servidor objetivo
### Funcion principal
Actuar como destino del trafico generado en el laboratorio y permitir observar comportamiento normal y afectacion bajo eventos anómalos.

### Responsabilidades
- exponer servicios simples y medibles;
- responder trafico del cliente;
- servir como objetivo para pruebas de acceso, trafico web y latencia;
- permitir observar impacto del enforcement o de las anomalias generadas.

### Software sugerido
- Ubuntu Server o Debian
- nginx o apache
- openssh-server
- iperf3 server (opcional)
- python simple HTTP server, si se desea un servicio minimo de prueba

### Recursos recomendados
- vCPU: 2
- RAM: 2 GB
- Disco: 20 GB
- Interfaces virtuales: 1

### Observacion tecnica
Debe mantener una configuracion simple y estable. Su funcion principal es servir de blanco observable del trafico del laboratorio.

## 6. Recursos globales del escenario
### Dimensionamiento total recomendado
- VM1 Sensor/ML: 4 vCPU / 8 GB / 60-80 GB
- VM2 Cliente: 2 vCPU / 2 GB / 20 GB
- VM3 Servidor: 2 vCPU / 2 GB / 20 GB

### Consumo total estimado
- CPU virtual total: 8 vCPU
- RAM total: 12 GB
- Disco total: 100 a 120 GB

Este consumo es razonable para una primera etapa del proyecto y deja margen dentro de un host con 400 GB para:
- snapshots;
- crecimiento del dataset;
- logs EVE JSON;
- resultados del modelo;
- respaldo documental.

## 7. Uso de interfaces de red fisicas
Actualmente se dispone de:
- una interfaz fisica para internet;
- una interfaz fisica para LAN.

### Recomendacion para la primera etapa
Para este escenario inicial no es obligatorio explotar ambas interfaces fisicas en una topologia compleja. Se recomienda:
- usar una red virtual interna para conectar las tres VMs del laboratorio;
- usar la conectividad a internet solo cuando sea necesaria para actualizaciones, instalacion de paquetes o pruebas puntuales;
- mantener el trafico principal del laboratorio dentro del segmento virtual controlado.

### Justificacion
- simplifica el despliegue;
- reduce errores de configuracion;
- evita dependencia temprana de una topologia fisica mas compleja;
- facilita migracion futura a un hipervisor mas robusto.

## 8. Flujo operativo esperado
La topologia debe soportar el siguiente flujo minimo:
1. La VM cliente genera trafico normal hacia la VM servidor.
2. La VM sensor observa el trafico del laboratorio y genera telemetria.
3. La telemetria se procesa en la misma VM sensor.
4. El modelo predictivo calcula score de anomalia.
5. El motor de decision interpreta el score.
6. El enforcement aplica una accion basica si corresponde.
7. Se registran resultados y evidencias del comportamiento del sistema.

## 9. Escenario inicial recomendado
### Escenario base del MVP
Se recomienda comenzar con un solo escenario funcional simple:
- trafico normal sostenido entre VM cliente y VM servidor;
- trafico anomalo puntual generado desde la VM cliente;
- observacion y registro desde la VM sensor.

### Alcance del escenario
Este escenario ya permite cubrir:
- captura inicial;
- construccion de dataset;
- entrenamiento offline;
- prueba de score;
- decision basica;
- primer enforcement controlado.

## 10. Responsabilidad de cada maquina en el MVP
| VM | Nombre funcional | Rol principal | Responsabilidad clave |
|---|---|---|---|
| VM1 | Sensor / ML / Control | Nucleo del producto | Captura, analitica, modelo, decision y enforcement |
| VM2 | Cliente | Generador de trafico | Originar trafico normal y anomalo |
| VM3 | Servidor | Objetivo del trafico | Proveer servicios y actuar como destino observable |

## 11. Lo que no se implementa en esta etapa
Para mantener foco y viabilidad, esta topologia inicial no incorpora:
- pfSense u OPNsense;
- SIEM comercial;
- ELK como nucleo del sistema;
- Kafka o arquitectura Big Data;
- multiples segmentos complejos;
- varias subredes empresariales;
- dominios Windows o infraestructura AD;
- varios sensores distribuidos.

## 12. Ventajas de esta topologia
Las principales ventajas de esta arquitectura inicial son:
- simplicidad de despliegue;
- bajo consumo de recursos;
- foco directo en el aporte real del PPI;
- facilidad de documentacion y reproduccion;
- menor tiempo de puesta en marcha;
- compatibilidad con migracion futura a una infraestructura mas robusta.

## 13. Limitaciones conocidas
Las limitaciones de esta primera topologia son las siguientes:
- menor realismo empresarial frente a una arquitectura con gateway dedicado;
- menor segmentacion de red;
- menor complejidad de trafico y contexto;
- enforcement inicial menos sofisticado.

Estas limitaciones son aceptables en esta etapa, dado que el objetivo es validar el MVP del producto y no reproducir un SOC o una infraestructura corporativa completa.

## 14. Ruta de evolucion futura
Cuando se disponga de un hipervisor mejor y mayores recursos, esta topologia podra evolucionar hacia:
- inclusion de una VM gateway dedicada como `pfSense` o `OPNsense`;
- segmentacion WAN/LAN mas realista;
- separacion entre sensor y motor de analitica;
- inclusion de una red de gestion independiente;
- pruebas con mas clientes, mas servidores y mas escenarios de trafico.

## 15. Conclusiones tecnicas
Para la etapa actual del proyecto, la topologia de tres maquinas virtuales sin `pfSense` es suficiente, adecuada y tecnicamente coherente con los objetivos del MVP. Esta arquitectura permite validar el flujo minimo del producto sin distraer recursos en componentes de infraestructura que, aunque utiles en etapas futuras, no son indispensables para demostrar el valor central del PPI.

La prioridad de esta etapa debe recaer en la VM sensor, ya que alli reside la parte innovadora del sistema: telemetria, modelo predictivo, decision y control. La VM cliente y la VM servidor cumplen una funcion de soporte experimental y deben mantenerse simples, estables y facilmente administrables.