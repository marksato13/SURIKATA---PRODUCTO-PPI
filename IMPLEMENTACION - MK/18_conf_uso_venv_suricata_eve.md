# Uso del venv, verificacion de Suricata y revision de eve.json

## 1. Proposito del documento
Este documento resume los comandos esenciales para trabajar en la VM sensor despues de la preparacion base. Su objetivo es mostrar como activar el entorno virtual `venv`, verificar que Suricata este operativo y revisar el archivo `eve.json` para confirmar que la telemetria del laboratorio ya esta disponible para las fases de datos y modelado.

## 2. Ruta base del trabajo
Para este bloque de trabajo se asume la ruta del proyecto:

```bash
/home/m4rk/ppi-sensor
```

## 3. Como activar el entorno virtual
### Entrar al proyecto
```bash
cd /home/m4rk/ppi-sensor
```

### Activar el `venv`
```bash
source /home/m4rk/ppi-sensor/venv/bin/activate
```

### Como saber que esta activo
Si se activa correctamente, el prompt mostrara algo como:

```bash
(venv)
```

## 4. Como verificar Python dentro del `venv`
```bash
python --version
```

## 5. Como verificar las librerias del MVP
```bash
python -c "import pandas, numpy, sklearn, matplotlib, seaborn; print('OK')"
```

### Resultado esperado
Si todo esta correcto, deberia aparecer:

```bash
OK
```

## 6. Como salir del entorno virtual
```bash
deactivate
```

## 7. Como verificar Suricata
### Ver version correcta
En esta instalacion se usa:

```bash
suricata -V
```

### Ver informacion de compilacion
```bash
suricata --build-info
```

### Confirmar que el proceso esta corriendo
```bash
ps aux | grep suricata
```

### Si Suricata no esta corriendo
La interfaz confirmada del laboratorio es `ens35`, por lo que puedes iniciarlo con:

```bash
sudo suricata -i ens35 -D
```

## 8. Como verificar que existe eve.json
```bash
sudo ls -lh /var/log/suricata/
```

### Archivos esperados
Deberias ver al menos algunos de estos:
- `eve.json`
- `stats.log`
- `suricata.log`

## 9. Como ver las ultimas lineas de eve.json
```bash
sudo tail -n 20 /var/log/suricata/eve.json
```

## 10. Como observar eve.json en tiempo real
```bash
sudo tail -f /var/log/suricata/eve.json
```

### Para salir del seguimiento
Presiona:

```bash
Ctrl + C
```

## 11. Como identificar tipos de evento dentro de eve.json
```bash
jq -r '.event_type' /var/log/suricata/eve.json | sort | uniq -c
```

### Lo que puede aparecer
- `flow`
- `alert`
- `stats`
- otros eventos segun configuracion y trafico del laboratorio

### Si jq no esta instalado
```bash
sudo apt update
sudo apt install -y jq
```

## 12. Como comprobar si ya existen eventos flow
```bash
grep '"event_type":"flow"' /var/log/suricata/eve.json | head
```

### Interpretacion
- Si aparecen lineas, ya existe base para crear el parser del dataset tabular.
- Si no aparecen lineas, debes revisar la configuracion de `eve-log`, el trafico generado o la captura de la interfaz.

## 13. Como guardar una muestra inicial para trabajo de datos
```bash
cp /var/log/suricata/eve.json /home/m4rk/ppi-sensor/data/raw/eve_inicial.json
```

### Verificar la copia
```bash
ls -lh /home/m4rk/ppi-sensor/data/raw/
```

## 14. Secuencia recomendada de trabajo
Ejecuta en este orden:

```bash
cd /home/m4rk/ppi-sensor
source /home/m4rk/ppi-sensor/venv/bin/activate
python --version
python -c "import pandas, numpy, sklearn, matplotlib, seaborn; print('OK')"
suricata -V
ps aux | grep suricata
sudo ls -lh /var/log/suricata/
sudo tail -n 20 /var/log/suricata/eve.json
jq -r '.event_type' /var/log/suricata/eve.json | sort | uniq -c
grep '"event_type":"flow"' /var/log/suricata/eve.json | head
cp /var/log/suricata/eve.json /home/m4rk/ppi-sensor/data/raw/eve_inicial.json
ls -lh /home/m4rk/ppi-sensor/data/raw/
```

## 15. Que debe confirmarse despues
Despues de ejecutar la secuencia anterior, deberias poder confirmar lo siguiente:
1. el `venv` esta funcionando correctamente;
2. Suricata esta activo;
3. `eve.json` existe y contiene eventos;
4. ya existen eventos `flow` para comenzar el parser.

## 16. Conclusiones tecnicas
Este bloque de comandos conecta la preparacion del entorno con el trabajo real de datos. Si el `venv` esta operativo, Suricata corre sobre `ens35`, `eve.json` existe y `flow` ya aparece en los eventos, entonces la VM sensor esta lista para entrar de lleno a la fase de parsing y transformacion del dataset del producto ingenieril.
