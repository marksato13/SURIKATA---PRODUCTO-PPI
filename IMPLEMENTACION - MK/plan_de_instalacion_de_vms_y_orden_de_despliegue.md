# Plan de instalacion de VMs y orden de despliegue

## 1. Proposito del documento
Este documento define el orden recomendado de creacion, configuracion e instalacion de las maquinas virtuales del laboratorio inicial del PPI. Su objetivo es reducir errores de despliegue, evitar retrabajo y asegurar que el entorno minimo quede operativo con el menor nivel de complejidad posible.

La logica del despliegue propuesta prioriza primero la conectividad basica del laboratorio, luego la disponibilidad de un servicio destino, despues la generacion de trafico y finalmente la activacion del nucleo real del producto: la VM de sensor, analitica, modelo y control.

## 2. Alcance del despliegue
El presente plan aplica a la topologia inicial sin `pfSense`, compuesta por tres maquinas virtuales:
- VM1: Sensor / ML / Control
- VM2: Cliente generador de trafico
- VM3: Servidor objetivo

## 3. Principios de despliegue
Se adoptan los siguientes principios:
1. Desplegar primero lo mas simple y observable.
2. Verificar conectividad antes de instalar herramientas complejas.
3. Evitar configurar Suricata o el modelo antes de tener trafico real que observar.
4. Mantener evidencias de cada paso para trazabilidad tecnica.

## 4. Orden recomendado de despliegue

## Etapa 1. Crear la red virtual del laboratorio
### Objetivo
Disponer de un segmento aislado o controlado donde se conectaran las tres VMs.

### Actividades
- Crear el vSwitch o red virtual interna del laboratorio.
- Definir un nombre unico para la red virtual.
- Confirmar que las tres VMs podran conectarse al mismo segmento.

### Resultado esperado
- red virtual de laboratorio lista para conectar VMs.

## Etapa 2. Desplegar primero la VM3 - Servidor objetivo
### Justificacion
El servidor objetivo debe existir antes que el cliente y antes que el sensor, porque es el destino mas sencillo para validar conectividad, latencia y flujo basico del laboratorio.

### Actividades
- Crear la VM servidor.
- Instalar el sistema operativo.
- Configurar IP estatica.
- Instalar servicios minimos de prueba:
  - SSH
  - HTTP simple
- Validar que la VM arranca correctamente.

### Resultado esperado
- servidor estable y accesible en la LAN del laboratorio.

## Etapa 3. Desplegar la VM2 - Cliente generador de trafico
### Justificacion
El cliente permite generar trafico observable hacia el servidor y validar la conectividad base antes de activar el sensor.

### Actividades
- Crear la VM cliente.
- Instalar el sistema operativo.
- Configurar IP estatica.
- Instalar herramientas base:
  - ping
  - curl
  - wget
  - hping3
  - iperf3, si aplica
- Validar conectividad hacia la VM servidor.

### Pruebas minimas
- ping al servidor
- acceso HTTP al servidor
- conexion SSH, si aplica

### Resultado esperado
- cliente capaz de generar trafico normal basico hacia el servidor.

## Etapa 4. Validar el laboratorio basico sin sensor
### Objetivo
Confirmar que el trafico entre cliente y servidor funciona correctamente antes de agregar la capa de observacion y analitica.

### Actividades
- Ejecutar trafico normal controlado.
- Confirmar estabilidad entre cliente y servidor.
- Verificar que las IPs y la red estan correctamente configuradas.

### Resultado esperado
- laboratorio funcional basico listo para instrumentacion.

## Etapa 5. Desplegar la VM1 - Sensor / ML / Control
### Justificacion
Esta VM es la mas importante del producto, pero no debe instalarse primero. Conviene incorporarla cuando ya exista trafico real dentro del laboratorio, para que las pruebas de captura sean inmediatas y verificables.

### Actividades
- Crear la VM sensor.
- Instalar el sistema operativo.
- Configurar IP estatica.
- Instalar componentes base:
  - Suricata
  - Python
  - librerias de procesamiento y ML
  - iptables
  - ipset
- Verificar conectividad con las otras VMs.

### Resultado esperado
- VM sensor lista para iniciar captura, procesamiento y control.

## Etapa 6. Instrumentacion inicial de la VM sensor
### Objetivo
Dejar lista la VM principal para capturar telemetria y ejecutar las primeras fases del producto.

### Actividades
- Configurar Suricata.
- Validar salida `EVE JSON`.
- Crear estructura de trabajo del proyecto:
  - datos crudos
  - datos procesados
  - scripts
  - modelos
  - resultados
  - docs
- Verificar que el trafico entre cliente y servidor produce eventos observables.

### Resultado esperado
- captura inicial funcional desde la VM sensor.

## 5. Secuencia resumida recomendada
| Orden | Maquina / recurso | Motivo |
|---|---|---|
| 1 | Red virtual del laboratorio | Base comun de conectividad |
| 2 | VM3 Servidor | Primer destino observable |
| 3 | VM2 Cliente | Generador de trafico normal y anomalo |
| 4 | Validacion cliente-servidor | Confirmar red basica funcional |
| 5 | VM1 Sensor / ML / Control | Activar nucleo del producto |
| 6 | Instrumentacion con Suricata | Iniciar captura y procesamiento |

## 6. Checklist tecnico por VM

## VM3 - Servidor
- VM creada
- SO instalado
- IP estatica configurada
- SSH activo
- servicio HTTP activo
- responde ping

## VM2 - Cliente
- VM creada
- SO instalado
- IP estatica configurada
- herramientas de generacion instaladas
- conectividad con servidor validada

## VM1 - Sensor
- VM creada
- SO instalado
- IP estatica configurada
- Suricata instalado
- Python y librerias instaladas
- captura EVE JSON validada

## 7. Recomendaciones practicas de instalacion
- Usar la misma familia Linux en las tres VMs para simplificar administracion.
- Configurar hostname claro y consistente desde el inicio.
- Reservar snapshots despues de la instalacion base de cada VM.
- No instalar herramientas no necesarias durante la primera etapa.
- Mantener una bitacora simple con fecha, cambios y estado de cada VM.

## 8. Riesgos de despliegue
### Riesgo 1. Configurar la VM sensor demasiado pronto
Impacto:
- se dificulta validar si el problema esta en la red o en la captura.

Mitigacion:
- primero validar cliente-servidor;
- despues activar el sensor.

### Riesgo 2. Desorden en nombres o direccionamiento
Impacto:
- genera confusion tecnica y errores de trazabilidad.

Mitigacion:
- usar convenciones fijas desde el inicio.

### Riesgo 3. Agregar herramientas innecesarias
Impacto:
- aumenta complejidad y tiempo de despliegue.

Mitigacion:
- limitarse al stack minimo viable.

## 9. Conclusiones tecnicas
El orden de despliegue recomendado no responde a una logica de importancia conceptual, sino a una logica de validacion practica. Aunque la VM sensor es el corazon del producto, primero deben existir el servidor y el cliente para que la captura y el modelado se apoyen sobre trafico real y observable. Este orden reduce incertidumbre, facilita diagnostico y permite construir el laboratorio de forma progresiva y controlada.