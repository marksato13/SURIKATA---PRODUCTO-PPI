# Servicios oficiales del laboratorio para el producto ingenieril

## 1. Proposito del documento
Este documento define formalmente los servicios que deben mantenerse en el laboratorio del PPI para producir trafico normal y anomalo util para el entrenamiento del modelo, la construccion del dataset y la validacion del sistema de deteccion temprana con control operativo.

Su objetivo es dejar claro que servicios se utilizaran, por que se eligieron, que papel juegan dentro de los distintos grupos de escenarios y que alternativas se descartan en esta etapa por complejidad o bajo valor metodologico.

## 2. Criterio de seleccion de servicios
Los servicios del laboratorio deben cumplir estas condiciones:
- ser tecnicamente simples de desplegar y mantener;
- producir telemetria util para Suricata y el parser;
- permitir trafico legitimo y tambien patrones anómalos controlados;
- ser defendibles metodologicamente con base en las fuentes revisadas;
- no inflar innecesariamente el alcance del producto.

## 3. Decision general
Para esta etapa del producto ingenieril, **no se recomienda levantar aun una aplicacion completa con frontend, backend y base de datos** como nucleo del laboratorio.

### Justificacion
Aunque una arquitectura web completa podria aportar mas variedad, en esta fase introduciria:
- mayor complejidad de despliegue;
- mas tiempo de mantenimiento;
- mas variables de falla;
- menos foco sobre el objetivo principal del PPI, que es la telemetria, el modelado, la decision y el control.

Por tanto, la estrategia correcta es utilizar servicios simples, medibles y suficientemente ricos para generar el trafico necesario.

## 4. Servicios oficiales del laboratorio

## 4.1 Servicio principal: HTTP interno con Nginx
### Tecnologia
- `nginx`

### Rol
- servicio principal para trafico legitimo del laboratorio;
- base del escenario A1;
- base de descargas y consultas repetidas;
- base del escenario de acceso repetitivo anomalo;
- soporte para escenarios mixtos.

### Justificacion tecnica
- DBIR destaca el valor ofensivo y operativo de aplicaciones y servicios expuestos;
- Cloudflare Radar refuerza la relevancia de capa de aplicacion como superficie de abuso;
- permite generar `flow` TCP con `app_proto` HTTP;
- facilita la produccion de trafico legitimo variado con `curl`, `wget` y navegador.

### Recomendacion operativa
No debe quedarse en una sola pagina estatica minima. Debe enriquecerse con rutas y recursos varios para aumentar diversidad de trafico.

## 4.2 Servicio secundario: SSH
### Tecnologia
- `openssh-server`

### Rol
- acceso remoto legitimo al servidor;
- base del escenario A2;
- soporte para transferencia con `scp`;
- soporte para acceso repetitivo o brute force controlado;
- componente util en escenarios mixtos.

### Justificacion tecnica
- DBIR y Fortinet destacan que los servicios remotos y las credenciales son objetivos frecuentes;
- Fortinet menciona SSH como uno de los servicios sometidos a presion de brute force;
- permite generar telemetria diferente a HTTP pero igualmente util para el dataset.

## 4.3 Servicio complementario: iperf3
### Tecnologia
- `iperf3`

### Rol
- enriquecer el laboratorio con sesiones de mayor volumen;
- aportar trafico sostenido o de rendimiento controlado;
- complementar el dataset con flujos de mayor throughput.

### Estado metodologico
- complementario;
- no debe ser el nucleo de la normalidad del entorno.

### Justificacion tecnica
- util para volumen y duracion de flujos;
- menos representativo del trafico cotidiano de usuario que HTTP o SSH;
- adecuado como apoyo, no como eje.

## 5. Servicios que no son prioritarios en esta etapa
En esta fase del producto, no se recomienda incorporar como servicios principales:

### DNS propio complejo
No es prioritario como servicio del laboratorio solo para simular floods.

### Aplicacion completa frontend + backend + base de datos
No es necesaria por ahora para justificar ni generar el trafico base del producto.

### Router, DHCP o servicios de infraestructura compleja
No son requisitos para producir `flow` util en el laboratorio.

### SIEM, ELK o Big Data como nucleo
No aportan valor proporcional en esta etapa y amplian demasiado el alcance.

## 6. Relacion entre servicios y escenarios

## 6.1 Grupo normal

### A1. Navegacion HTTP legitima
Servicio principal:
- `nginx`

### A2. SSH legitimo
Servicio principal:
- `openssh-server`

### A3. Transferencia de archivos legitima
Servicios:
- `nginx`
- `openssh-server` mediante `scp`

### A4. Trafico sostenido
Servicios:
- `nginx`
- `openssh-server`
- `iperf3` opcional

### A5. Rendimiento controlado
Servicio:
- `iperf3`

## 6.2 Grupo anomalo

### B1. SYN flood
Objetivo principal:
- puerto `80` de `nginx`

Objetivo alternativo:
- puerto `22` de `ssh`

### B2. Port scan
Objetivo:
- servidor `192.168.0.120`

Servicios observables:
- `nginx`
- `ssh`

### B3. UDP flood
Objetivo:
- host `192.168.0.120`

### B4. ICMP flood
Objetivo:
- host `192.168.0.120`
o complemento hacia `192.168.0.20`

### B5. Acceso repetitivo anomalo
Servicio principal:
- `nginx`

Servicio secundario opcional:
- `ssh`

### B6. Brute force controlado
Servicio principal:
- `openssh-server`

## 6.3 Grupo mixto

### C1. HTTP legitimo + SYN flood
- normal sobre `nginx`
- anomalo sobre `nginx`

### C2. SSH legitimo + port scan
- normal sobre `ssh`
- anomalo sobre servidor o subred

### C3. Descarga legitima + UDP flood
- normal sobre `nginx`
- anomalo sobre host/servicio del servidor

## 7. Mejora recomendada del servicio web
Para que `nginx` produzca trafico mas util, se recomienda que no sirva un unico archivo, sino una estructura basica como esta:

```text
/var/www/html/
├── index.html
├── info.html
├── health.html
├── files/
│   ├── manual.txt
│   ├── sample.csv
│   ├── report.log
│   └── archivo_grande.bin
└── img/
    ├── logo.png
    └── banner.jpg
```

### Valor de esta mejora
Permite generar:
- solicitudes a multiples rutas;
- descargas pequenas y medianas;
- mas variacion de bytes y duracion;
- mejor trafico HTTP normal.

## 8. Formula defendible para el documento tecnico
Una forma defendible de describir esta decision seria:

> El laboratorio emplea servicios internos simples pero funcionales, seleccionados por su capacidad de producir telemetria de red util, reproducible y controlada. En particular, se prioriza un servicio HTTP basado en Nginx y un servicio SSH, por representar tanto trafico legitimo cotidiano como superficies razonables para patrones de abuso, reconocimiento y denegacion controlada. De manera complementaria, se incorpora iperf3 en corridas especificas para enriquecer el volumen y la duracion de ciertos flujos.

## 9. Conclusiones tecnicas
La mejor configuracion de servicios para esta etapa del producto ingenieril no es la mas compleja, sino la mas util. Un servidor con `nginx` y `openssh-server`, complementado opcionalmente por `iperf3`, ofrece un equilibrio adecuado entre realismo, control experimental, simplicidad operativa y valor para el dataset. Esta combinacion es suficiente para sostener escenarios normales, anomalos y mixtos sin desviar el foco del proyecto hacia una arquitectura de aplicaciones que, por ahora, no es necesaria.
