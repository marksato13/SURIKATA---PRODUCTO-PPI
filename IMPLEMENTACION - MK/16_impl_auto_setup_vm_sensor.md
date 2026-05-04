# Automatizacion de preparacion de la VM sensor del MVP

## 1. Proposito del documento
Este documento describe el uso del script `setup_vm_sensor_mvp.sh`, creado para automatizar la preparacion base de la VM sensor / ML / control del producto PPI. Su finalidad es ejecutar en una sola secuencia la instalacion de herramientas, la creacion de estructura del proyecto, la configuracion del entorno virtual, la instalacion de librerias del MVP, la validacion inicial de Suricata y la generacion de un reporte en formato `.txt` con lo instalado y verificado.

## 2. Archivo principal
Script generado:

```bash
setup_vm_sensor_mvp.sh
```

## 3. Que automatiza el script
El script automatiza lo siguiente:
- actualizacion del sistema;
- instalacion de herramientas base;
- instalacion de herramientas de red y captura;
- instalacion de `Suricata`;
- instalacion de Python, `pip` y `venv`;
- creacion de la estructura del proyecto `ppi-sensor`;
- instalacion de librerias Python del MVP;
- generacion de `requirements.txt`;
- verificacion de la interfaz `ens35`;
- prueba basica de conectividad con cliente y servidor;
- validacion de version de Suricata;
- arranque de Suricata si no esta corriendo;
- copia inicial de `eve.json` a `data/raw`;
- generacion de un reporte `.txt` final con el inventario de instalacion.

## 4. Rutas usadas por el script
### Proyecto
```bash
/home/m4rk/ppi-sensor
```

### Reporte de salida
```bash
/home/m4rk/ppi-sensor/docs/install_report_vm_sensor.txt
```

## 5. Interfaz y direcciones usadas
- interfaz de captura: `ens35`
- cliente del laboratorio: `192.168.0.20`
- servidor del laboratorio: `192.168.0.120`

## 6. Como usar el script
### Dar permisos de ejecucion
```bash
chmod +x setup_vm_sensor_mvp.sh
```

### Ejecutarlo
```bash
sudo bash setup_vm_sensor_mvp.sh
```

## 7. Archivo `.txt` generado al final
El script genera un archivo de reporte con:
- fecha de ejecucion;
- version de Python;
- version de Suricata;
- paquetes instalados relevantes;
- estructura del proyecto;
- listado de logs de Suricata;
- tipos de evento detectados en `eve.json`;
- estado del proceso `suricata`;
- verificacion de muestra inicial en `data/raw`.

Ruta esperada del reporte:

```bash
/home/m4rk/ppi-sensor/docs/install_report_vm_sensor.txt
```

## 8. Recomendacion de uso
Usa este script como automatizacion base de la VM sensor. Despues de ejecutarlo, el siguiente paso ya no es instalacion, sino validacion de eventos `flow`, preservacion del `eve_inicial.json` y desarrollo del primer parser `parse_eve_to_csv.py`.

## 9. Conclusiones tecnicas
El script `setup_vm_sensor_mvp.sh` convierte el procedimiento manual de preparacion de la VM sensor en una secuencia reproducible, trazable y alineada con el MVP del producto. Ademas, el reporte `.txt` final deja evidencia util para documentacion tecnica, control de instalacion y seguimiento de la implementacion del entorno.
