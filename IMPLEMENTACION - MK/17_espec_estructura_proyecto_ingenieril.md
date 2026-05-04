# Estructura del proyecto ingenieril del PPI

## 1. Proposito del documento
Este documento define una estructura de carpetas viable y coherente con el producto ingenieril del PPI. Su objetivo es ordenar el trabajo tecnico del MVP segun el flujo real del proyecto: captura, datos, features, modelado, decision, enforcement, evaluacion y documentacion.

## 2. Principio de la estructura
La estructura propuesta no responde a una aplicacion empresarial completa, sino a un MVP de laboratorio tecnicamente ordenado. Debe ser:
- simple de navegar;
- suficientemente modular para crecer;
- alineada con las fases del producto;
- util tanto para codigo como para evidencia y documentacion.

## 3. Ruta raiz propuesta
```bash
/home/m4rk/ppi-surikata-producto
```

## 4. Estructura recomendada
```text
/home/m4rk/ppi-surikata-producto/
├── config/
├── data/
│   ├── raw/
│   ├── staging/
│   └── processed/
├── models/
│   ├── trained/
│   └── metrics/
├── scripts/
│   ├── setup/
│   ├── capture/
│   ├── data/
│   ├── model/
│   ├── decision/
│   ├── enforcement/
│   └── evaluation/
├── src/
│   ├── ingest/
│   ├── features/
│   ├── models/
│   ├── decision/
│   ├── enforcement/
│   └── evaluation/
├── logs/
│   ├── suricata/
│   └── system/
├── results/
│   ├── reports/
│   ├── figures/
│   └── tables/
├── docs/
│   ├── bitacora/
│   ├── evidencia/
│   └── info/
├── venv/
└── README.txt
```

## 5. Logica de organizacion por bloques

## 5.1 Bloque de configuracion
### `config/`
Aqui van los parametros de configuracion del proyecto:
- nombres de interfaces;
- umbrales `t1` y `t2`;
- rutas usadas por scripts;
- referencias de IPs y nombres de host;
- configuraciones auxiliares.

## 5.2 Bloque de datos
### `data/raw/`
Telemetria cruda sin procesar. Es la entrada base del pipeline.

### `data/staging/`
Zona intermedia de trabajo. Aqui van transformaciones preliminares antes del dataset final.

### `data/processed/`
Dataset tabular listo para modelado, evaluacion o exportacion.

## 5.3 Bloque de modelos
### `models/trained/`
Modelos entrenados persistentes.

### `models/metrics/`
Resultados cuantitativos del entrenamiento y validacion.

## 5.4 Bloque de scripts ejecutables
### `scripts/setup/`
Preparacion del entorno e instalacion.

### `scripts/capture/`
Captura y copia de telemetria.

### `scripts/data/`
Parseo, limpieza y transformacion de datos.

### `scripts/model/`
Entrenamiento y seleccion de modelos.

### `scripts/decision/`
Logica de umbrales y politicas operativas.

### `scripts/enforcement/`
Bloqueo, listas, reglas y control basico.

### `scripts/evaluation/`
Metricas, validacion y consolidacion de resultados.

## 5.5 Bloque de codigo fuente reutilizable
### `src/ingest/`
Funciones reutilizables de lectura de telemetria.

### `src/features/`
Funciones reutilizables para generar variables base y derivadas.

### `src/models/`
Codigo reusable de entrenamiento, carga, prediccion y exportacion.

### `src/decision/`
Codigo reusable para transformar score a accion.

### `src/enforcement/`
Codigo reusable para control operativo sobre trafico.

### `src/evaluation/`
Codigo reusable para metricas, tablas y validacion.

## 5.6 Bloque de logs
### `logs/suricata/`
Copias organizadas de logs importantes del sensor.

### `logs/system/`
Salidas, errores y trazas de scripts del proyecto.

## 5.7 Bloque de resultados
### `results/reports/`
Reportes tecnicos y salidas consolidadas.

### `results/figures/`
Graficos y figuras de apoyo.

### `results/tables/`
Tablas exportadas de metricas y comparativas.

## 5.8 Bloque documental
### `docs/bitacora/`
Seguimiento cronologico del trabajo tecnico.

### `docs/evidencia/`
Capturas, comprobaciones y evidencias del laboratorio.

### `docs/info/`
Informacion auxiliar sobre estructura, convenciones y ayudas operativas.

## 5.9 Entorno virtual
### `venv/`
Entorno Python del proyecto. Aisla dependencias y evita contaminar el sistema base.

## 6. Por que esta estructura si es coherente con tu producto
Esta estructura sigue el flujo real del producto ingenieril:
1. capturas datos con Suricata;
2. guardas telemetria cruda;
3. transformas datos;
4. construyes features;
5. entrenas modelo;
6. tomas decisiones;
7. aplicas enforcement;
8. validas y documentas.

No es una estructura generica de software cualquiera. Esta alineada al comportamiento tecnico del MVP.

## 7. Script de creacion automatica
El archivo:

```bash
setup_project_structure_ppi.sh
```

automatiza la creacion de esta estructura y genera un archivo `.txt` con la descripcion de cada carpeta.

## 8. Archivo `.txt` informativo generado
Ruta esperada:

```bash
/home/m4rk/ppi-surikata-producto/docs/info/carpetas_y_proposito.txt
```

Este archivo resume el concepto de cada carpeta para consulta rapida dentro del entorno Linux.

## 9. Recomendacion operativa
No mezclar esta nueva raiz del proyecto con carpetas auxiliares como `ppi-lab` o `ppi-sensor` si ya vas a ordenar el trabajo del producto. Si decides adoptar esta estructura como principal, conviene usarla como raiz definitiva del MVP y dejar las otras como transitorias o auxiliares.

## 10. Conclusiones tecnicas
La estructura propuesta es viable, escalable para el MVP y coherente con el producto ingenieril. No es excesivamente grande, pero tampoco se queda corta. Ordena el trabajo por funcion tecnica y por fase del producto, permitiendo que el proyecto crezca sin perder trazabilidad entre captura, datos, modelo, decision, control y evaluacion.
