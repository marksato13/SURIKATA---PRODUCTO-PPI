# Direccionamiento IP y parametros de red del laboratorio

## 1. Proposito del documento
Este documento define una propuesta inicial de direccionamiento IP y parametros de red para la topologia minima del laboratorio del PPI. Su objetivo es establecer una configuracion simple, consistente y facil de administrar, que permita desplegar las tres VMs del escenario inicial sin `pfSense` y con el menor nivel de complejidad operativa posible.

## 2. Criterios de diseno
La propuesta se construye con los siguientes criterios:
- simplicidad para despliegue rapido;
- direccionamiento privado y aislado;
- facilidad de identificacion de roles;
- coherencia con una red virtual interna de laboratorio;
- posibilidad de escalar despues sin romper la logica base.

## 3. Red recomendada del laboratorio
### Segmento propuesto
- Red: `192.168.50.0/24`
- Mascara: `255.255.255.0`
- Tipo: LAN virtual interna de laboratorio

### Justificacion
Se propone una unica red `/24` porque:
- es suficiente para el escenario inicial;
- simplifica configuracion manual;
- evita complejidad innecesaria de subredes en esta etapa;
- es facilmente migrable a una topologia futura mas segmentada.

## 4. Asignacion de direcciones IP
| VM | Nombre sugerido | IP propuesta | Rol |
|---|---|---|---|
| VM1 | `sensor-mk` | `192.168.50.10` | Sensor, analitica, modelo, decision y enforcement |
| VM2 | `cliente-mk` | `192.168.50.20` | Generador de trafico normal y anomalo |
| VM3 | `servidor-mk` | `192.168.50.30` | Destino del trafico y servicios de prueba |

## 5. Parametros por VM

## 5.1 VM1 - Sensor / ML / Control
- Hostname sugerido: `sensor-mk`
- IP: `192.168.50.10`
- Mascara: `255.255.255.0`
- Gateway:
  - opcional o vacio si la red sera completamente interna;
  - si se requiere salida controlada a internet, definir segun el esquema del host o gateway temporal.
- DNS:
  - opcional si no hay salida a internet;
  - si se requiere actualizacion de paquetes, usar DNS publico o local segun el entorno.

## 5.2 VM2 - Cliente
- Hostname sugerido: `cliente-mk`
- IP: `192.168.50.20`
- Mascara: `255.255.255.0`
- Gateway: mismo criterio que la VM sensor
- DNS: mismo criterio que la VM sensor

## 5.3 VM3 - Servidor
- Hostname sugerido: `servidor-mk`
- IP: `192.168.50.30`
- Mascara: `255.255.255.0`
- Gateway: mismo criterio que la VM sensor
- DNS: mismo criterio que la VM sensor

## 6. Uso de gateway y salida a internet
### Opcion A. Laboratorio totalmente interno
Esta es la opcion mas simple para la primera etapa.

Caracteristicas:
- las tres VMs solo se comunican entre si;
- no hay salida directa a internet desde la LAN del laboratorio;
- el trafico experimental permanece completamente aislado.

Ventajas:
- menor riesgo;
- mayor control;
- menos variables de red;
- mas facil de documentar.

Desventajas:
- actualizacion de paquetes o descargas requiere soluciones temporales.

### Opcion B. Salida a internet controlada solo cuando sea necesaria
Caracteristicas:
- se mantiene la LAN de laboratorio como red principal;
- se habilita salida solo para instalacion de paquetes o mantenimiento;
- el trafico experimental sigue concentrado dentro de la LAN virtual.

Recomendacion:
- usar esta opcion solo para tareas administrativas;
- no depender de internet como parte del escenario experimental base.

## 7. Interfaz de red por VM
Para el escenario inicial se recomienda una sola interfaz virtual por VM, conectada a la LAN interna del laboratorio.

| VM | Interfaz virtual recomendada | Conexion |
|---|---|---|
| VM1 Sensor | `eth0` | LAN virtual `192.168.50.0/24` |
| VM2 Cliente | `eth0` | LAN virtual `192.168.50.0/24` |
| VM3 Servidor | `eth0` | LAN virtual `192.168.50.0/24` |

### Justificacion
- simplifica configuracion inicial;
- reduce puntos de falla;
- permite concentrarse en el MVP del producto.

## 8. Nombre de red virtual sugerido
Se recomienda usar un nombre claro y estable para el segmento del laboratorio, por ejemplo:
- `LAB-MK-PPI`
- `LAN-PPI-MK`
- `PPI-LAB-SEG-01`

El nombre debe ser unico, reconocible y consistente en toda la documentacion.

## 9. Parametros de servicios de prueba
### VM3 - Servidor
Servicios sugeridos:
- SSH: puerto `22`
- HTTP: puerto `80`
- HTTPS: opcional en fase posterior
- iperf3 server: opcional

### VM2 - Cliente
Capacidades sugeridas:
- ping hacia `192.168.50.30`
- `curl http://192.168.50.30`
- `hping3` hacia `192.168.50.30`

### VM1 - Sensor
Capacidades sugeridas:
- observacion de trafico del segmento
- lectura de `EVE JSON`
- procesamiento local del dataset

## 10. Convencion de nombres recomendada
Se recomienda usar una convencion simple y estable:
- Hostnames:
  - `sensor-mk`
  - `cliente-mk`
  - `servidor-mk`
- Segmento:
  - `LAB-MK-PPI`
- Archivos de evidencia:
  - `YYYYMMDD_tipo_escenario_origen_destino`

Esto mejora trazabilidad y orden documental.

## 11. Pruebas minimas de conectividad
Una vez configuradas las IPs, deben ejecutarse al menos las siguientes pruebas:
1. `cliente-mk` hace ping a `servidor-mk`.
2. `cliente-mk` accede al servicio web de `servidor-mk`.
3. `sensor-mk` puede alcanzar por red al cliente y al servidor.
4. El trafico entre cliente y servidor es observable desde la VM sensor.

## 12. Riesgos de configuracion
### Riesgo 1. Direccionamiento inconsistente
Impacto:
- errores de conectividad y trazabilidad.

Mitigacion:
- usar IPs fijas desde el inicio;
- documentar todo hostname e IP.

### Riesgo 2. Dependencia excesiva de internet
Impacto:
- introduce ruido y hace menos controlado el laboratorio.

Mitigacion:
- limitar uso de internet a tareas administrativas.

### Riesgo 3. Cambios frecuentes de red virtual
Impacto:
- rompe capturas, scripts y referencias documentales.

Mitigacion:
- fijar nombre y segmento desde el inicio.

## 13. Propuesta final resumida
### Red base
- `192.168.50.0/24`

### Asignacion recomendada
- `192.168.50.10` -> `sensor-mk`
- `192.168.50.20` -> `cliente-mk`
- `192.168.50.30` -> `servidor-mk`

### Interfaces
- una interfaz virtual por VM en la LAN del laboratorio

### Gateway
- opcional en esta etapa si el laboratorio es interno

## 14. Conclusiones tecnicas
El direccionamiento propuesto prioriza simplicidad y control. Para el escenario inicial del PPI no se requiere una arquitectura de red compleja; una sola LAN virtual con IPs estaticas es suficiente para construir un entorno defendible, reproducible y facil de migrar posteriormente. Esta decision permite concentrar recursos y tiempo en la parte central del producto, evitando que la administracion de red eclipse el valor tecnico real del proyecto.