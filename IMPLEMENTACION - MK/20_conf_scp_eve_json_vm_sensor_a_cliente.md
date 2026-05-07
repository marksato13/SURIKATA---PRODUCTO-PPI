# Transferencia de eve_inicial.json por SCP desde la VM sensor a la VM cliente

## 1. Proposito del documento
Este documento explica como transferir el archivo `eve_inicial.json` desde la VM sensor `192.168.0.110` hacia la VM cliente `192.168.0.20` utilizando `scp`. Su objetivo es facilitar la extraccion de la muestra inicial de telemetria para inspeccion, validacion, respaldo o revision posterior.

## 2. Escenario actual
### VM origen
- VM sensor
- IP: `192.168.0.110`
- Archivo a transferir:

```bash
/home/m4rk/ppi-sensor/data/raw/eve_inicial.json
```

### VM destino
- VM cliente Ubuntu Desktop
- IP: `192.168.0.20`
- Usuario: `m4rk`

## 3. Recomendacion principal
La forma mas simple es ejecutar `scp` desde la VM cliente, trayendo el archivo desde la VM sensor.

## 4. Comando recomendado para copiar al Escritorio
Ejecutar en la VM cliente `192.168.0.20`:

```bash
scp m4rk@192.168.0.110:/home/m4rk/ppi-sensor/data/raw/eve_inicial.json /home/m4rk/Escritorio/
```

## 5. Comando alternativo para copiar a Descargas
Ejecutar en la VM cliente `192.168.0.20`:

```bash
scp m4rk@192.168.0.110:/home/m4rk/ppi-sensor/data/raw/eve_inicial.json /home/m4rk/Descargas/
```

## 6. Que ocurrira al ejecutar el comando
### Si ya configuraste clave SSH
La copia deberia realizarse directamente sin pedir contrasena.

### Si aun no configuraste acceso sin contrasena
El sistema pedira la contrasena del usuario remoto `m4rk` en la VM sensor.

Contrasena esperada:

```text
cisco123
```

## 7. Como verificar que el archivo llego correctamente

### Si lo copiaste al Escritorio
```bash
ls -lh /home/m4rk/Escritorio/eve_inicial.json
```

### Si lo copiaste a Descargas
```bash
ls -lh /home/m4rk/Descargas/eve_inicial.json
```

## 8. Copiar toda la carpeta raw (opcional)
Si deseas traer toda la carpeta `raw` en lugar de solo un archivo:

```bash
scp -r m4rk@192.168.0.110:/home/m4rk/ppi-sensor/data/raw /home/m4rk/Descargas/
```

## 9. Opcion inversa: enviar desde la VM sensor hacia la VM cliente
Tambien se puede ejecutar el envio desde la VM sensor `192.168.0.110`, aunque no es la opcion mas comoda en este escenario.

Comando:

```bash
scp /home/m4rk/ppi-sensor/data/raw/eve_inicial.json m4rk@192.168.0.20:/home/m4rk/Descargas/
```

## 10. Recomendacion operativa
Para este laboratorio se recomienda usar siempre la opcion desde la VM cliente, porque:
- simplifica la extraccion del archivo;
- evita trabajar de mas sobre la VM sensor;
- facilita despues mover el archivo al host o revisarlo visualmente.

## 11. Comando mas recomendado para este caso
Usar este comando exacto desde la VM cliente:

```bash
scp m4rk@192.168.0.110:/home/m4rk/ppi-sensor/data/raw/eve_inicial.json /home/m4rk/Escritorio/
```

## 12. Uso posterior del archivo
Una vez copiado, `eve_inicial.json` puede usarse para:
- inspeccion visual del contenido;
- validacion de campos minimos de F1;
- apoyo al cierre de la fase de captura base;
- entrada para el parser `parse_eve_to_csv.py`;
- respaldo local de la muestra inicial.

## 13. Conclusiones tecnicas
La transferencia por `scp` desde la VM sensor a la VM cliente es una forma simple y segura de extraer la muestra inicial de telemetria. Para este proyecto, la operacion recomendada es ejecutarla desde la VM cliente y dejar el archivo en `Escritorio` o `Descargas`, de modo que quede listo para revision, validacion y uso posterior en la fase de parsing del dataset.
