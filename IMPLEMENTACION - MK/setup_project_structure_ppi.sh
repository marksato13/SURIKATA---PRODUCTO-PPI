#!/usr/bin/env bash

set -euo pipefail

USER_NAME="m4rk"
USER_HOME="/home/${USER_NAME}"
PROJECT_ROOT="${USER_HOME}/ppi-surikata-producto"
INFO_DIR="${PROJECT_ROOT}/docs/info"

echo "[1/4] Creando estructura del proyecto ingenieril..."

mkdir -p "${PROJECT_ROOT}/config"
mkdir -p "${PROJECT_ROOT}/data/raw"
mkdir -p "${PROJECT_ROOT}/data/staging"
mkdir -p "${PROJECT_ROOT}/data/processed"
mkdir -p "${PROJECT_ROOT}/models/trained"
mkdir -p "${PROJECT_ROOT}/models/metrics"
mkdir -p "${PROJECT_ROOT}/scripts/setup"
mkdir -p "${PROJECT_ROOT}/scripts/capture"
mkdir -p "${PROJECT_ROOT}/scripts/data"
mkdir -p "${PROJECT_ROOT}/scripts/model"
mkdir -p "${PROJECT_ROOT}/scripts/decision"
mkdir -p "${PROJECT_ROOT}/scripts/enforcement"
mkdir -p "${PROJECT_ROOT}/scripts/evaluation"
mkdir -p "${PROJECT_ROOT}/src/ingest"
mkdir -p "${PROJECT_ROOT}/src/features"
mkdir -p "${PROJECT_ROOT}/src/models"
mkdir -p "${PROJECT_ROOT}/src/decision"
mkdir -p "${PROJECT_ROOT}/src/enforcement"
mkdir -p "${PROJECT_ROOT}/src/evaluation"
mkdir -p "${PROJECT_ROOT}/logs/suricata"
mkdir -p "${PROJECT_ROOT}/logs/system"
mkdir -p "${PROJECT_ROOT}/results/reports"
mkdir -p "${PROJECT_ROOT}/results/figures"
mkdir -p "${PROJECT_ROOT}/results/tables"
mkdir -p "${PROJECT_ROOT}/docs/bitacora"
mkdir -p "${PROJECT_ROOT}/docs/evidencia"
mkdir -p "${PROJECT_ROOT}/docs/info"
mkdir -p "${PROJECT_ROOT}/venv"

echo "[2/4] Generando archivo de informacion de carpetas..."

cat > "${INFO_DIR}/carpetas_y_proposito.txt" <<'EOF'
ESTRUCTURA DEL PROYECTO INGENIERIL PPI

Ruta raiz:
/home/m4rk/ppi-surikata-producto

1. config/
Contiene configuraciones del proyecto, parametros base, rutas, umbrales y referencias tecnicas reutilizables.

2. data/raw/
Contiene telemetria cruda sin procesar. Aqui van copias de `eve.json`, muestras originales y cualquier entrada base del laboratorio.

3. data/staging/
Contiene datos intermedios entre lo crudo y lo procesado. Sirve para limpieza parcial, filtrado preliminar y transformaciones temporales.

4. data/processed/
Contiene datasets tabulares listos para modelado, entrenamiento, validacion o pruebas analiticas.

5. models/trained/
Contiene modelos entrenados, serializados o exportados. Por ejemplo, archivos `.pkl` u otros formatos persistentes.

6. models/metrics/
Contiene metricas, evaluaciones, comparaciones de modelos y resultados numericos del proceso analitico.

7. scripts/setup/
Contiene scripts de preparacion del entorno, instalacion y configuracion inicial del laboratorio.

8. scripts/capture/
Contiene scripts relacionados con captura de trafico, copia de logs y preparacion de telemetria.

9. scripts/data/
Contiene scripts para parseo de EVE JSON, limpieza, transformacion y generacion de datasets.

10. scripts/model/
Contiene scripts de entrenamiento, seleccion de modelo, serializacion y pruebas del clasificador.

11. scripts/decision/
Contiene scripts de logica de decision, evaluacion de score y definicion de umbrales.

12. scripts/enforcement/
Contiene scripts para iptables, ipset y acciones de enforcement basicas del MVP.

13. scripts/evaluation/
Contiene scripts para medir resultados, consolidar metricas, evaluar escenarios y registrar salidas del producto.

14. src/ingest/
Contiene codigo fuente reutilizable para ingesta y lectura estructurada de telemetria.

15. src/features/
Contiene funciones y modulos reutilizables para generar variables base y derivadas.

16. src/models/
Contiene implementacion reutilizable de modelos, carga, entrenamiento y prediccion.

17. src/decision/
Contiene logica reutilizable para transformar score en acciones operativas.

18. src/enforcement/
Contiene codigo reutilizable para acoplar decision y control sobre el trafico.

19. src/evaluation/
Contiene codigo reutilizable para metricas, validacion y generacion de resultados.

20. logs/suricata/
Contiene copias organizadas de logs de Suricata relevantes para el proyecto.

21. logs/system/
Contiene logs auxiliares del sistema, errores, eventos de ejecucion y salidas de scripts.

22. results/reports/
Contiene reportes tecnicos, resumentes y salidas consolidadas del MVP.

23. results/figures/
Contiene imagenes, graficos y figuras generadas durante el analisis o evaluacion.

24. results/tables/
Contiene tablas de resultados, metricas y comparativas exportadas.

25. docs/bitacora/
Contiene bitacoras de trabajo, seguimiento de cambios y anotaciones tecnicas del proceso.

26. docs/evidencia/
Contiene capturas, pruebas y evidencia documental del laboratorio y del producto.

27. docs/info/
Contiene informacion auxiliar del proyecto, como este archivo, guias internas y referencias operativas.

28. venv/
Contiene el entorno virtual Python del proyecto.
EOF

echo "[3/4] Generando README basico de la raiz..."

cat > "${PROJECT_ROOT}/README.txt" <<'EOF'
PROYECTO INGENIERIL PPI
Deteccion temprana de comportamientos anomalos en redes de datos mediante modelos predictivos y un mecanismo de control inline.

Esta carpeta contiene la estructura tecnica base del MVP del producto ingenieril.

Orden de trabajo recomendado:
1. config
2. data/raw
3. scripts/setup
4. scripts/capture
5. scripts/data
6. scripts/model
7. scripts/decision
8. scripts/enforcement
9. scripts/evaluation
10. results
11. docs
EOF

echo "[4/4] Ajustando propietario y mostrando arbol..."
chown -R "${USER_NAME}:${USER_NAME}" "${PROJECT_ROOT}"
tree "${PROJECT_ROOT}" || true

echo
echo "Estructura creada en: ${PROJECT_ROOT}"
echo "Archivo de informacion: ${INFO_DIR}/carpetas_y_proposito.txt"
