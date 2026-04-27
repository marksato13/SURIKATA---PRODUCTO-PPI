# Rutas, navegacion por carpetas y uso del entorno virtual del proyecto

## 1. Proposito del documento
Este documento describe las rutas base del proyecto en la VM sensor, como desplazarse entre carpetas con `cd`, como verificar el contenido de cada directorio y como activar correctamente el entorno virtual `venv` del MVP. Su objetivo es dejar una guia operativa clara para no perderse en la estructura del proyecto durante la implementacion tecnica.

## 2. Ruta base del proyecto en la VM sensor
La ruta base de trabajo del proyecto en la VM sensor es:

```bash
/home/m4rk/ppi-sensor
```

Si estas logueado como el usuario `m4rk`, tambien puedes referirte a esta carpeta como:

```bash
~/ppi-sensor
```

## 3. Estructura principal del proyecto
La estructura base recomendada es la siguiente:

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

## 4. Como ir a la carpeta principal del proyecto
### Opcion con ruta completa
```bash
cd /home/m4rk/ppi-sensor
```

### Opcion usando el home del usuario
```bash
cd ~/ppi-sensor
```

### Verificar donde estas
```bash
pwd
```

El resultado esperado debe ser:

```bash
/home/m4rk/ppi-sensor
```

## 5. Como entrar a cada carpeta del proyecto

## 5.1 Carpeta de datos crudos
```bash
cd /home/m4rk/ppi-sensor/data/raw
```

Uso:
- guardar muestras iniciales de `eve.json`;
- conservar telemetria sin procesar.

## 5.2 Carpeta de datos procesados
```bash
cd /home/m4rk/ppi-sensor/data/processed
```

Uso:
- guardar CSVs procesados;
- guardar dataset tabular listo para modelado.

## 5.3 Carpeta de scripts
```bash
cd /home/m4rk/ppi-sensor/scripts
```

Uso:
- guardar parsers;
- guardar scripts de automatizacion;
- guardar scripts de evaluacion y utilidades del proyecto.

## 5.4 Carpeta de modelos
```bash
cd /home/m4rk/ppi-sensor/models
```

Uso:
- guardar modelos entrenados;
- guardar serializaciones como `.pkl` o formatos equivalentes.

## 5.5 Carpeta de resultados
```bash
cd /home/m4rk/ppi-sensor/results
```

Uso:
- guardar metricas;
- guardar tablas de resultados;
- guardar salidas de evaluacion.

## 5.6 Carpeta de documentacion
```bash
cd /home/m4rk/ppi-sensor/docs
```

Uso:
- notas tecnicas;
- bitacoras;
- documentacion auxiliar del laboratorio.

## 5.7 Carpeta del entorno virtual
```bash
cd /home/m4rk/ppi-sensor/venv
```

Uso:
- entorno virtual Python del proyecto.

## 6. Como volver rapidamente a la carpeta principal
Si estas en cualquier subcarpeta del proyecto, puedes volver con:

```bash
cd /home/m4rk/ppi-sensor
```

o si sigues dentro del arbol del proyecto:

```bash
cd ..
```

Pero la forma mas segura siempre es usar la ruta completa.

## 7. Como listar el contenido de cada carpeta
### Listado simple
```bash
ls
```

### Listado detallado
```bash
ls -l
```

### Listado del arbol completo del proyecto
```bash
tree /home/m4rk/ppi-sensor
```

Si `tree` no esta instalado:

```bash
sudo apt update
sudo apt install -y tree
```

## 8. Como activar el entorno virtual `venv`
Estando en cualquier carpeta, puedes activar el entorno virtual con:

```bash
source /home/m4rk/ppi-sensor/venv/bin/activate
```

Si estas dentro de la carpeta principal del proyecto, tambien puedes usar:

```bash
source venv/bin/activate
```

### Como saber que esta activado
Veras algo similar a esto al inicio del prompt:

```bash
(venv)
```

Ejemplo:

```bash
(venv) m4rk@sensor:/home/m4rk/ppi-sensor$
```

## 9. Como desactivar el entorno virtual
```bash
deactivate
```

## 10. Como verificar que el `venv` esta funcionando
### Ver version de Python dentro del entorno
```bash
python --version
```

### Probar librerias del MVP
```bash
python -c "import pandas, numpy, sklearn; print('OK')"
```

Si aparece `OK`, el entorno esta listo para trabajar.

## 11. Comandos base recomendados al iniciar trabajo en la VM sensor
Cada vez que empieces una sesion tecnica, puedes seguir esta secuencia:

```bash
cd /home/m4rk/ppi-sensor
source /home/m4rk/ppi-sensor/venv/bin/activate
pwd
ls
```

## 12. Secuencias practicas de navegacion

## 12.1 Ir a la carpeta de datos crudos y revisar muestra inicial
```bash
cd /home/m4rk/ppi-sensor/data/raw
ls -lh
```

## 12.2 Ir a la carpeta de scripts para crear el parser
```bash
cd /home/m4rk/ppi-sensor/scripts
ls -l
```

## 12.3 Volver a la raiz del proyecto y activar `venv`
```bash
cd /home/m4rk/ppi-sensor
source venv/bin/activate
```

## 12.4 Ir a resultados despues de ejecutar un script
```bash
cd /home/m4rk/ppi-sensor/results
ls -l
```

## 13. Comando recomendado para crear la estructura si aun no existe
Si todavia no existe la estructura del proyecto, puedes crearla con:

```bash
mkdir -p /home/m4rk/ppi-sensor/{data/raw,data/processed,docs,models,results,scripts}
```

## 14. Comando recomendado para crear el `venv` si aun no existe
```bash
python3 -m venv /home/m4rk/ppi-sensor/venv
```

Luego activarlo con:

```bash
source /home/m4rk/ppi-sensor/venv/bin/activate
```

## 15. Instalacion base de librerias dentro del `venv`
Con el entorno activado:

```bash
pip install --upgrade pip
pip install pandas numpy scikit-learn matplotlib seaborn jupyterlab
```

## 16. Guardar dependencias del entorno
```bash
pip freeze > /home/m4rk/ppi-sensor/requirements.txt
```

## 17. Diferencia entre trabajar como `m4rk` y como `root`
### Recomendacion
Trabaja el proyecto como `m4rk` y usa `sudo` solo cuando sea necesario para:
- instalar paquetes;
- leer logs del sistema;
- arrancar o detener Suricata;
- modificar reglas del sistema.

### Evita
- crear archivos del proyecto en `/root`;
- mezclar rutas de `root` con rutas de `m4rk`;
- ejecutar todo como `root` cuando no es necesario.

## 18. Verificaciones rapidas recomendadas
### Ver la raiz del proyecto
```bash
cd /home/m4rk/ppi-sensor && pwd && ls
```

### Verificar `venv`
```bash
source /home/m4rk/ppi-sensor/venv/bin/activate
python -c "import pandas, numpy, sklearn; print('OK')"
```

### Verificar datos crudos
```bash
ls -lh /home/m4rk/ppi-sensor/data/raw
```

### Verificar scripts
```bash
ls -l /home/m4rk/ppi-sensor/scripts
```

## 19. Resumen operativo rapido
### Entrar al proyecto
```bash
cd /home/m4rk/ppi-sensor
```

### Activar el entorno virtual
```bash
source venv/bin/activate
```

### Ir a scripts
```bash
cd /home/m4rk/ppi-sensor/scripts
```

### Ir a datos crudos
```bash
cd /home/m4rk/ppi-sensor/data/raw
```

### Volver a la raiz
```bash
cd /home/m4rk/ppi-sensor
```

### Salir del entorno virtual
```bash
deactivate
```

## 20. Conclusiones tecnicas
Tener rutas claras y una forma estandar de navegar por el proyecto evita muchos errores operativos durante la implementacion. En esta VM, la disciplina de trabajo debe ser simple: entrar siempre a `/home/m4rk/ppi-sensor`, activar `venv`, trabajar por carpetas segun la fase del MVP y usar `sudo` solo cuando la operacion sea realmente del sistema. Esa organizacion facilita captura, parsing, modelado y documentacion del producto ingenieril.
