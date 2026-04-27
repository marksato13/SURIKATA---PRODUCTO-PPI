# Preparacion completa de la VM sensor / ML / control

## 1. Proposito del documento
Este documento describe el paso a paso tecnico para preparar la VM sensor / ML / control del producto PPI. Su objetivo es dejar la maquina lista para cumplir el rol central del MVP: capturar telemetria de red, procesarla, construir dataset, ejecutar el modelo predictivo y servir de base para la toma de decisiones y el control inline posterior.

El enfoque del documento es practico. No se orienta a teoria general, sino a implementacion real del entorno de trabajo en la VM principal del laboratorio.

## 2. Identificacion de la VM
- Nombre funcional: VM sensor / ML / control
- IP actual: `192.168.0.110`
- Sistema operativo: Ubuntu Server
- Rol dentro del laboratorio:
  - sensor de red;
  - procesamiento de telemetria;
  - feature engineering;
  - entrenamiento y evaluacion del modelo;
  - motor de decision;
  - base del enforcement.

## 3. Objetivo tecnico de la preparacion
Dejar la VM `192.168.0.110` completamente preparada para:
- capturar trafico con `Suricata`;
- generar eventos `EVE JSON`;
- almacenar telemetria cruda;
- procesar datos con `Python`;
- construir dataset tabular;
- entrenar `Isolation Forest`;
- preparar la base tecnica para `iptables/ipset` y futuras acciones inline.

## 4. Que se instalara y para que sirve

## 4.1 Herramientas del sistema
### `net-tools`
- Uso: verificar IPs, interfaces y estado de red.

### `curl`
- Uso: pruebas basicas de conectividad HTTP y descarga.

### `wget`
- Uso: descarga de archivos y pruebas de acceso.

### `jq`
- Uso: inspeccionar rapidamente archivos `JSON`, especialmente `eve.json`.

### `tree`
- Uso: visualizar estructura de carpetas del proyecto.

### `git`
- Uso: versionado local y sincronizacion del trabajo tecnico.

## 4.2 Herramientas de captura y red
### `Suricata`
- Uso: sensor IDS/IPS del proyecto.
- Funcion en el MVP: capturar trafico y producir telemetria estructurada en `EVE JSON`.

### `tcpdump`
- Uso: captura de red de bajo nivel.
- Funcion en el MVP: validar que el trafico existe en la interfaz antes de depender de Suricata.

### `iptables`
- Uso: reglas de control de trafico.
- Funcion en el MVP: base del enforcement inicial.

### `ipset`
- Uso: manejo eficiente de conjuntos de IPs.
- Funcion en el MVP: bloqueo dinamico por IP o listas temporales.

### `iproute2`
- Uso: herramientas de red modernas, incluyendo `tc`.
- Funcion en el MVP: base para posible accion de limitar en iteracion posterior.

## 4.3 Entorno Python y analitica
### `python3`
- Uso: entorno principal de desarrollo.

### `python3-pip`
- Uso: instalacion de librerias Python.

### `python3-venv`
- Uso: crear entorno virtual del proyecto.

### `pandas`
- Uso: transformacion tabular de telemetria.

### `numpy`
- Uso: operaciones numericas y soporte de features.

### `scikit-learn`
- Uso: implementacion de `Isolation Forest`.

### `matplotlib` y `seaborn`
- Uso: visualizacion basica de distribuciones y scores.

### `jupyterlab` u opcional `notebook`
- Uso: exploracion rapida del dataset y pruebas de analitica.
- Nota: opcional; no es obligatorio para el MVP, pero ayuda bastante en laboratorio.

## 5. Secuencia general de preparacion
La preparacion debe hacerse en este orden:
1. actualizar el sistema;
2. verificar red e interfaz;
3. instalar herramientas base del sistema;
4. instalar herramientas de red y captura;
5. instalar Python y entorno virtual;
6. crear estructura del proyecto;
7. instalar y validar Suricata;
8. validar `EVE JSON`;
9. preparar directorios para datos y scripts;
10. dejar lista la base para modelado.

## 6. Paso a paso de implementacion

## Paso 1. Actualizar el sistema operativo
```bash
sudo apt update && sudo apt upgrade -y
```

### Objetivo
Partir de un entorno actualizado y reducir problemas de dependencias.

## Paso 2. Verificar conectividad y red
```bash
ip a
ip route
ping -c 4 192.168.0.20
ping -c 4 192.168.0.120
```

### Objetivo
Confirmar que la VM sensor tiene conectividad con el cliente y el servidor del laboratorio.

### Evidencia esperada
- interfaz de red identificada;
- respuesta de red desde y hacia las VMs del laboratorio.

## Paso 3. Instalar utilidades base del sistema
```bash
sudo apt install -y net-tools curl wget jq tree git unzip vim
```

### Objetivo
Contar con herramientas minimas de administracion, validacion y trabajo diario.

## Paso 4. Instalar herramientas de red y captura
```bash
sudo apt install -y tcpdump iptables ipset iproute2
```

### Objetivo
Preparar la base tecnica de observacion y control del trafico.

## Paso 5. Instalar Suricata
```bash
sudo apt install -y suricata
```

### Verificar instalacion
```bash
suricata --build-info
suricata --version
```

### Objetivo
Dejar instalado el sensor principal del MVP.

## Paso 6. Identificar la interfaz de captura
```bash
ip a
```

### Objetivo
Determinar sobre que interfaz observara el trafico Suricata.

### Recomendacion
Anotar el nombre real de la interfaz, por ejemplo:
- `ens33`
- `eth0`
- `enp0s3`

No asumir el nombre; primero verificarlo en la VM.

## Paso 7. Probar trafico visible con tcpdump
Suponiendo que la interfaz detectada sea `ens33`:

```bash
sudo tcpdump -i ens33 -c 20
```

### Objetivo
Verificar que realmente hay trafico observable antes de depender de Suricata.

## Paso 8. Revisar la configuracion de Suricata
Archivo principal esperado:
```bash
/etc/suricata/suricata.yaml
```

### Revisiones minimas
- interfaz de captura;
- habilitacion de `eve-log`;
- tipo de eventos a registrar;
- ruta de logs.

### Verificar `eve.json`
Revisar que `eve-log` este habilitado y que incluya al menos:
- `flow`
- `alert`
- `stats` si aplica

## Paso 9. Iniciar Suricata en prueba
Ejemplo suponiendo `ens33`:

```bash
sudo suricata -i ens33 -D
```

### Verificar proceso
```bash
ps aux | grep suricata
```

### Verificar logs
```bash
sudo ls -l /var/log/suricata/
sudo tail -f /var/log/suricata/eve.json
```

### Objetivo
Confirmar que Suricata ya genera telemetria util para el proyecto.

## Paso 10. Instalar Python y entorno virtual
```bash
sudo apt install -y python3 python3-pip python3-venv
```

### Crear estructura base del proyecto
```bash
mkdir -p /home/m4rk/ppi-sensor/{data/raw,data/processed,models,scripts,results,docs}
```

### Crear entorno virtual
```bash
python3 -m venv /home/m4rk/ppi-sensor/venv
source /home/m4rk/ppi-sensor/venv/bin/activate
```

### Objetivo
Separar el entorno del proyecto y evitar contaminar el sistema global.

## Paso 11. Instalar librerias Python del MVP
Con el entorno virtual activado:

```bash
pip install --upgrade pip
pip install pandas numpy scikit-learn matplotlib seaborn jupyterlab
```

### Objetivo
Dejar preparada la capa de analitica, dataset y modelado.

## Paso 12. Crear archivo de requerimientos
```bash
pip freeze > /home/m4rk/ppi-sensor/requirements.txt
```

### Objetivo
Guardar trazabilidad de dependencias del entorno.

## Paso 13. Ajustar permisos del espacio de trabajo
```bash
sudo chown -R m4rk:m4rk /home/m4rk/ppi-sensor
```

### Objetivo
Evitar trabajar como `root` sobre archivos del proyecto cuando no sea necesario.

## Paso 14. Validar telemetria inicial
Con Suricata corriendo, genera trafico desde la VM cliente y observa:

```bash
sudo tail -f /var/log/suricata/eve.json
```

### Objetivo
Confirmar que la VM sensor ya cumple su primera responsabilidad: producir telemetria observable y util.

## Paso 15. Copiar una muestra inicial de trabajo
```bash
cp /var/log/suricata/eve.json /home/m4rk/ppi-sensor/data/raw/eve_inicial.json
```

### Objetivo
Guardar un primer archivo crudo para las fases de parsing y feature engineering.

## 7. Estructura recomendada del proyecto en la VM sensor
```text
/home/m4rk/ppi-sensor/
├── data/
│   ├── raw/
│   └── processed/
├── docs/
├── models/
├── results/
├── scripts/
├── venv/
└── requirements.txt
```

## 8. Para que usaras esta VM en el MVP

## 8.1 En Fase 1
- instalar y validar Suricata;
- capturar telemetria inicial;
- almacenar `EVE JSON`.

## 8.2 En Fase 2
- parsear `EVE JSON`;
- construir dataset tabular;
- generar features base y derivadas.

## 8.3 En Fase 3
- entrenar `Isolation Forest`;
- medir scores;
- probar umbrales `t1` y `t2`.

## 8.4 En Fase 4
- convertir score en decision;
- preparar `iptables/ipset`;
- ejecutar bloqueo inicial controlado.

## 8.5 En Fase 5
- observar resultados;
- registrar evidencias;
- validar comportamiento del MVP.

## 9. Checklist final de preparacion
La VM se considera preparada si al final puedes confirmar todo lo siguiente:
- la VM responde en red a `192.168.0.20` y `192.168.0.120`;
- `Suricata` esta instalado;
- existe `eve.json` en `/var/log/suricata/`;
- se observan eventos reales en `eve.json`;
- Python y `venv` estan operativos;
- `pandas`, `numpy` y `scikit-learn` estan instalados;
- existe una estructura de proyecto ordenada;
- hay al menos una muestra inicial copiada a `data/raw`.

## 10. Comandos de verificacion rapida
```bash
suricata --version
python3 --version
source /home/m4rk/ppi-sensor/venv/bin/activate
python -c "import pandas, numpy, sklearn; print('OK')"
sudo ls -l /var/log/suricata/
ls -R /home/m4rk/ppi-sensor
```

## 11. Problemas comunes

## 11.1 No aparece `eve.json`
Posibles causas:
- `Suricata` no inicio bien;
- la interfaz elegida es incorrecta;
- `eve-log` no esta habilitado;
- no hay trafico observable.

## 11.2 Suricata corre pero no ve trafico
Posibles causas:
- interfaz equivocada;
- red virtual mal conectada;
- el trafico no pasa por donde la VM sensor puede observarlo.

## 11.3 Python no reconoce librerias
Posibles causas:
- entorno virtual no activado;
- instalacion hecha fuera del `venv`.

## 11.4 Problemas de permisos
Posibles causas:
- archivos creados como `root`;
- trabajo mezclado entre rutas de `root` y `m4rk`.

## 12. Recomendacion operativa final
Haz la instalacion del sistema con `sudo`, pero el trabajo del proyecto diario hazlo como `m4rk`. Eso te evitara mezclar rutas, permisos y archivos del producto con el home de `root`.

## 13. Conclusiones tecnicas
La VM `192.168.0.110` es la pieza central del MVP. Su preparacion no debe limitarse a instalar Suricata; debe dejarse lista tambien para datos, analitica, modelado y control. Cuando esta VM queda correctamente preparada, el proyecto ya dispone de la base real para ejecutar todas las fases del producto ingenieril, desde la captura hasta la decision operativa.
