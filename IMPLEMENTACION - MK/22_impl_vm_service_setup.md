# Instalacion paso a paso de la VM servidor del laboratorio

## 1. Proposito del documento
Este documento describe la preparacion tecnica de la VM servidor del laboratorio, correspondiente a `192.168.0.120`, con el fin de dejarla lista como destino del trafico normal y anomalo del MVP. El objetivo es habilitar servicios simples, medibles y utiles para generar flujos observables por Suricata y apoyar la construccion del dataset del producto ingenieril.

## 2. Identificacion de la VM
- Nombre funcional: VM servidor / servicio interno
- IP actual: `192.168.0.120`
- Sistema operativo: Ubuntu Server
- Prompt de trabajo esperado:

```bash
root@service:/home/m4rk#
```

## 3. Objetivo tecnico de la preparacion
Dejar la VM servidor preparada para:
- responder trafico HTTP normal desde la VM cliente;
- aceptar conexiones SSH legitimas desde el laboratorio;
- servir como destino principal del trafico anomalo generado por Kali;
- producir trafico suficiente y medible para que Suricata observe mas eventos `flow`.

## 4. Servicios recomendados para el MVP

## 4.1 Servicio principal: Nginx
### Uso
- exponer contenido web simple;
- permitir pruebas con `curl`, `wget` y navegador;
- generar trafico HTTP repetible y facil de medir.

## 4.2 Servicio secundario: OpenSSH Server
### Uso
- acceso remoto controlado;
- sesiones legitimas de administracion;
- generacion de flujos TCP utiles para el laboratorio.

## 4.3 Servicio opcional: iperf3 server
### Uso
- pruebas de transferencia de trafico sostenido;
- escenarios de rendimiento o carga controlada;
- enriquecimiento del dataset con trafico adicional.

## 5. Secuencia general de instalacion
La instalacion debe hacerse en este orden:
1. actualizar el sistema;
2. verificar conectividad de red;
3. instalar utilidades base;
4. instalar `nginx`;
5. instalar y validar `openssh-server`;
6. instalar `iperf3` opcional;
7. validar puertos y servicios;
8. generar una pagina simple de prueba;
9. confirmar acceso desde la VM cliente y la VM atacante.

## 6. Paso a paso de implementacion

## Paso 1. Actualizar el sistema operativo
Ejecutar desde:

```bash
root@service:/home/m4rk#
```

Comando:

```bash
apt update && apt upgrade -y
```

### Objetivo
Partir de un sistema actualizado y reducir problemas de dependencias.

## Paso 2. Verificar conectividad de red
Comandos:

```bash
ip a
ip route
ping -c 4 192.168.0.20
ping -c 4 192.168.0.110
ping -c 4 192.168.0.100
```

### Objetivo
Confirmar conectividad con:
- cliente Ubuntu Desktop `192.168.0.20`
- sensor Suricata `192.168.0.110`
- Kali `192.168.0.100`

### Evidencia esperada
- interfaz de red identificada;
- respuestas ICMP correctas en el laboratorio.

## Paso 3. Instalar utilidades base
Comando:

```bash
apt install -y net-tools curl wget vim git tree
```

### Objetivo
Contar con utilidades minimas para administracion, validacion y pruebas.

## Paso 4. Instalar Nginx
Comando:

```bash
apt install -y nginx
```

### Habilitar servicio
```bash
systemctl enable nginx
systemctl start nginx
```

### Verificar estado
```bash
systemctl status nginx --no-pager
```

### Objetivo
Dejar un servicio HTTP activo como destino de trafico normal y de pruebas controladas.

## Paso 5. Validar Nginx localmente
Comandos:

```bash
curl http://127.0.0.1
curl http://192.168.0.120
```

### Resultado esperado
Debe responder el contenido web por defecto de Nginx o la pagina que luego personalices.

## Paso 6. Instalar OpenSSH Server
Comando:

```bash
apt install -y openssh-server
```

### Habilitar servicio
```bash
systemctl enable ssh
systemctl start ssh
```

### Verificar estado
```bash
systemctl status ssh --no-pager
```

### Objetivo
Dejar acceso remoto legitimo disponible para administracion y generacion de flujos SSH en el laboratorio.

## Paso 7. Validar puertos activos
Comando:

```bash
ss -tulpn
```

### Que debe aparecer
Como minimo, deberias ver:
- puerto `80` para `nginx`
- puerto `22` para `ssh`

## Paso 8. Instalar iperf3 (opcional recomendado)
Comando:

```bash
apt install -y iperf3
```

### Uso en pruebas
Se puede levantar manualmente cuando lo necesites:

```bash
iperf3 -s
```

### Objetivo
Preparar una fuente adicional de trafico medible si luego quieres generar sesiones mas pesadas o de mayor duracion.

## Paso 9. Crear una pagina simple de prueba
Editar el archivo principal de Nginx:

```bash
nano /var/www/html/index.nginx-debian.html
```

Contenido sugerido:

```html
<html>
  <head><title>Servidor PPI MK</title></head>
  <body>
    <h1>Servidor interno del laboratorio PPI</h1>
    <p>Servicio HTTP activo en 192.168.0.120</p>
  </body>
</html>
```

### Objetivo
Facilitar pruebas visibles y trazables de acceso HTTP desde otras VMs.

## Paso 10. Validar acceso desde el cliente Ubuntu Desktop
Desde `192.168.0.20`, ejecutar:

```bash
curl http://192.168.0.120
ping -c 4 192.168.0.120
ssh m4rk@192.168.0.120
```

### Objetivo
Confirmar que el servidor ya recibe trafico legitimo desde el cliente del laboratorio.

## Paso 11. Validar acceso desde Kali
Desde `192.168.0.100`, ejecutar:

```bash
ping -c 4 192.168.0.120
nmap 192.168.0.120
```

### Objetivo
Confirmar que el servidor ya puede actuar como blanco de trafico anomalo o de reconocimiento controlado.

## Paso 12. Verificacion final local del servidor
En `192.168.0.120`, ejecutar:

```bash
hostname
ip a
systemctl status nginx --no-pager
systemctl status ssh --no-pager
ss -tulpn
curl http://127.0.0.1
```

## 7. Servicios que debe tener listos esta VM
La VM servidor se considera correctamente preparada si cumple esto:
- responde en `192.168.0.120`;
- `nginx` esta activo;
- `ssh` esta activo;
- el puerto `80` esta abierto;
- el puerto `22` esta abierto;
- el cliente Ubuntu Desktop puede acceder;
- Kali puede alcanzar el servidor y usarlo como objetivo controlado.

## 8. Para que usaras esta VM en el MVP

## 8.1 En Fase 1
- validar conectividad del laboratorio;
- producir trafico basico con servicios reales.

## 8.2 En Fase 2
- actuar como destino del trafico normal y anomalo;
- ayudar a generar mas eventos `flow` en Suricata.

## 8.3 En Fase 3
- sostener flujos suficientes para construir dataset y features.

## 8.4 En Fase 4 y F5
- actuar como blanco operativo para decisiones `PERMIT`, `LIMIT` y `BLOCK`.

## 8.5 En Fase 6
- servir de referencia para escenarios de validacion y experimentacion.

## 9. Problemas comunes

## 9.1 Nginx no responde
Posibles causas:
- servicio no iniciado;
- error de configuracion;
- puerto 80 no levantado.

## 9.2 SSH no responde
Posibles causas:
- `openssh-server` no instalado;
- servicio no iniciado;
- puerto 22 no activo.

## 9.3 Kali o Ubuntu Desktop no alcanzan el servidor
Posibles causas:
- error de red del laboratorio;
- IP incorrecta;
- desconexion de interfaz virtual.

## 10. Recomendacion operativa final
Para el MVP no hace falta sobrecargar esta VM con demasiados servicios. Con `nginx` y `openssh-server` ya tienes un servidor muy util para trafico legitimo, pruebas de conectividad y destino del trafico anomalo controlado. `iperf3` se puede dejar como servicio opcional de apoyo.

## 11. Conclusiones tecnicas
La VM `192.168.0.120` debe configurarse como un servidor interno simple, estable y medible. Su funcion no es complejidad, sino utilidad experimental: debe responder al trafico normal del cliente, recibir trafico anomalo del atacante y producir sesiones observables por Suricata. Si esto se logra, la fase de entorno queda mucho mas solida y el laboratorio ya puede pasar a escenarios de trafico con mejor valor para el dataset del producto ingenieril.
