# Fase 2. Ingesta, limpieza y feature engineering

## 1. Identificacion de la fase
- Proyecto: Deteccion temprana de comportamientos anomalos en redes de datos mediante modelos predictivos y un mecanismo de control inline.
- Fase: Fase 2. Ingesta, limpieza y feature engineering.
- Periodo de ejecucion: Semana 2, del 8 al 14 de mayo.
- Naturaleza de la fase: transformacion y preparacion analitica de datos.
- Dependencia: requiere la salida valida de la Fase 1, especialmente telemetria EVE JSON con trazabilidad temporal y campos minimos confirmados.

## 2. Proposito de la fase
Esta fase tiene como finalidad convertir la telemetria cruda obtenida por Suricata en un dataset analitico estructurado, consistente y util para el entrenamiento y evaluacion de modelos de deteccion de anomalias. Su objetivo no es aun modelar, sino construir una base de datos tabular confiable que preserve trazabilidad con la fuente original, reduzca ruido y exprese el comportamiento del trafico mediante variables significativas para el MVP del producto.

## 3. Objetivo especifico
Transformar la telemetria en un dataset analitico usable, implementando un parser de EVE JSON, definiendo la estructura tabular inicial, construyendo features base y derivadas, y dejando lista una primera particion de datos para pruebas offline.

## 4. Resultados esperados
Al cierre de la semana, esta fase debe producir los siguientes resultados:
- parser funcional para lectura de EVE JSON;
- dataset tabular inicial orientado a observaciones por flujo;
- conjunto definido de features base y derivadas para el MVP;
- reglas documentadas de limpieza y transformacion;
- particion temporal de datos para entrenamiento, validacion y prueba;
- primer dataset limpio listo para modelado offline;
- diccionario de variables del dataset.

## 5. Entregables formales
Los entregables de la fase son los siguientes:
1. Especificacion del esquema tabular del dataset.
2. Parser de EVE JSON o procedimiento documentado de conversion a tabla analitica.
3. Lista formal de features base y derivadas del MVP.
4. Reglas de limpieza y transformacion de datos.
5. Definicion de la particion temporal train/validation/test.
6. Primer dataset limpio para modelado.
7. Diccionario de variables y cierre tecnico de la semana 2.

## 6. Alcance de la fase
### Incluye
- lectura de eventos EVE JSON generados en la fase anterior;
- seleccion de la unidad de analisis del dataset;
- definicion del esquema tabular inicial;
- construccion de features base y derivadas;
- reglas de limpieza, codificacion y normalizacion si aplica;
- definicion de la particion temporal para pruebas offline;
- documentacion de variables y consistencia del dataset.

### No incluye
- entrenamiento definitivo de modelos;
- comparacion formal de modelos;
- ajuste de hiperparametros;
- integracion inline;
- ejecucion de acciones de control sobre trafico.

## 7. Precondiciones tecnicas
Antes de ejecutar esta fase deben cumplirse las siguientes condiciones:
- disponibilidad de archivos EVE JSON provenientes de la Fase 1;
- identificacion de campos tecnicos minimos presentes en la telemetria;
- separacion inicial de muestras normales y anomalas o al menos trazabilidad temporal para distinguirlas;
- entorno de trabajo organizado con carpetas para datos crudos y datos procesados;
- disponibilidad de herramientas de procesamiento, principalmente Python y librerias de manejo tabular.

## 8. Criterio tecnico de partida
Para esta fase se recomienda adoptar como unidad inicial de analisis el flujo de red. Esta decision responde a cuatro razones tecnicas:
1. Suricata ya produce informacion estructurada orientada a flow y metadata asociada.
2. El enfoque por flujo es mas simple y estable para el MVP.
3. Isolation Forest se adapta bien a datos tabulares por observacion.
4. Reducir la complejidad metodologica en mayo es prioritario frente a esquemas hibridos o secuenciales.

Por tanto, salvo que la evidencia de datos indique lo contrario, la semana 2 debe construirse sobre una estructura inicial por flujo.

## 9. Criterios de aceptacion de la fase
La fase se considerara satisfactoria si se cumplen los siguientes criterios:
1. El EVE JSON puede convertirse de forma reproducible a una tabla analitica.
2. La unidad de analisis queda definida y justificada documentalmente.
3. Existe una lista cerrada de features base y derivadas para el MVP.
4. Las reglas de limpieza de nulos, duplicados, extremos y codificacion quedan establecidas.
5. El dataset final de la semana puede dividirse en entrenamiento, validacion y prueba sin fuga temporal evidente.
6. El dataset limpio mantiene trazabilidad suficiente con la fuente original.
7. Se dispone de un diccionario de variables entendible y util para la Fase 3.

## 10. Lineamientos tecnicos de la fase
### 10.1 Unidad de analisis recomendada
- Unidad inicial: flujo.
- Opciones consideradas:
  - por flujo;
  - por IP en ventana;
  - esquema hibrido.
- Decision recomendada para mayo: por flujo.

### 10.2 Tipos de features previstos
- Features base de flujo.
- Features derivadas de razon, tasa o promedio.
- Features temporales simples si la calidad de timestamps lo permite.

### 10.3 Principio metodologico
La prioridad de esta fase no es maximizar cantidad de variables, sino construir un conjunto pequeno, interpretable y consistente que soporte el MVP sin abrir complejidad innecesaria.

## 11. Cronograma operativo diario

## Dia 8. Definicion del esquema tabular y unidad de analisis
### Objetivo del dia
Definir la forma estructural del dataset analitico y cerrar la decision sobre la unidad de observacion que se utilizara en el modelado inicial.

### Actividades
- Revisar los campos disponibles en la telemetria EVE JSON.
- Definir el esquema del dataset tabular:
  - nombre de columnas;
  - tipo de dato esperado;
  - relacion con campos fuente.
- Evaluar las posibles unidades de analisis:
  - por flujo;
  - por IP en ventana;
  - esquema hibrido.
- Tomar la decision tecnica inicial.
- Documentar la recomendacion de partir por flujo para el MVP.

### Salida esperada
- esquema tabular inicial aprobado;
- unidad de analisis definida formalmente.

### Evidencia a conservar
- esquema preliminar de columnas;
- justificacion escrita de la unidad de analisis elegida.

## Dia 9. Definicion de features base
### Objetivo del dia
Construir la lista inicial de variables base que representaran cada observacion del dataset y priorizar solo las necesarias para el MVP.

### Actividades
- Diseñar la lista inicial de features base procedentes directamente de Suricata.
- Priorizar variables con mayor utilidad esperada para deteccion de anomalias y menor complejidad de implementacion.
- Excluir temporalmente campos irrelevantes, ruidosos o de baja disponibilidad.
- Definir una primera lista minima viable de variables.

### Features base sugeridas
- `flow_id`
- `src_ip`
- `dest_ip`
- `src_port`
- `dest_port`
- `proto`
- `app_proto`
- `bytes_toserver`
- `bytes_toclient`
- `pkts_toserver`
- `pkts_toclient`
- `flow_duration`
- timestamp de referencia

### Salida esperada
- lista inicial de features base del MVP.

### Evidencia a conservar
- tabla de variables base seleccionadas;
- nota de variables descartadas o pospuestas.

## Dia 10. Definicion de features derivadas
### Objetivo del dia
Diseñar variables derivadas que mejoren la capacidad descriptiva del dataset sin aumentar en exceso la complejidad del pipeline.

### Actividades
- Diseñar las primeras features derivadas del proyecto.
- Definir formula, significado tecnico y condicion de calculo para cada una.
- Priorizar variables derivadas simples, interpretables y estables.

### Features derivadas sugeridas
- `tasa_bytes_total = (bytes_toserver + bytes_toclient) / duracion`
- `ratio_cliente_servidor = bytes_toserver / (bytes_toclient + 1)`
- `ratio_pkts = pkts_toserver / (pkts_toclient + 1)`
- `promedio_bytes_por_paquete = (bytes_toserver + bytes_toclient) / (pkts_toserver + pkts_toclient + 1)`
- `frecuencia_por_ip` dentro de una ventana de observacion, si la trazabilidad temporal ya lo permite

### Salida esperada
- lista de features derivadas con su definicion tecnica.

### Evidencia a conservar
- documento de formulas o tabla de transformaciones;
- justificacion de cada feature derivada adoptada.

## Dia 11. Definicion de reglas de limpieza y transformacion
### Objetivo del dia
Establecer criterios reproducibles para tratar problemas de calidad de datos antes del modelado.

### Actividades
- Definir tratamiento de valores nulos.
- Definir criterio para deteccion y eliminacion de duplicados.
- Establecer estrategia frente a valores extremos o inconsistentes.
- Definir codificacion de variables categoricas, especialmente:
  - `proto`;
  - `app_proto`.
- Documentar si se aplicara normalizacion o estandarizacion en esta fase o si quedara condicionada al modelo.

### Lineamientos recomendados
- Mantener regla explicita para nulos: eliminar, imputar o marcar.
- Considerar registros duplicados por clave tecnica o coincidencia fuerte de campos.
- No eliminar automaticamente todos los extremos; primero distinguir entre outlier real y error de dato.
- Codificar categorias de forma consistente y documentada.

### Salida esperada
- reglas formales de limpieza y transformacion del dataset.

### Evidencia a conservar
- matriz de decisiones de limpieza;
- criterios de codificacion y tratamiento de extremos.

## Dia 12. Definicion de particion temporal
### Objetivo del dia
Diseñar la estrategia de separacion de datos para pruebas offline, evitando fuga de informacion entre entrenamiento y evaluacion.

### Actividades
- Definir particion temporal del dataset en:
  - entrenamiento;
  - validacion;
  - prueba.
- Establecer criterio cronologico de separacion.
- Verificar que escenarios o periodos de anomalia no contaminen el conjunto de entrenamiento base, segun la estrategia del modelo.
- Documentar la logica de particion adoptada.

### Recomendacion tecnica
Para un modelo como Isolation Forest, se recomienda construir el entrenamiento principalmente sobre trafico normal o sobre el segmento mas representativo de normalidad, reservando el trafico anomalo para evaluacion y calibracion.

### Salida esperada
- esquema de particion temporal definido y documentado.

### Evidencia a conservar
- rango temporal de cada subconjunto;
- nota metodologica de prevencion de fuga temporal.

## Dia 13. Construccion del primer dataset limpio
### Objetivo del dia
Materializar el primer dataset listo para modelado y documentar formalmente las variables construidas.

### Actividades
- Ejecutar el parser o procedimiento de conversion de EVE JSON a tabla.
- Aplicar reglas de limpieza y transformacion definidas.
- Generar las features base y derivadas del MVP.
- Exportar el primer dataset limpio para modelado.
- Documentar el diccionario de variables:
  - nombre;
  - tipo;
  - origen;
  - descripcion;
  - transformacion si aplica.

### Salida esperada
- primer dataset limpio para modelado offline;
- diccionario de variables version 1.

### Evidencia a conservar
- archivo del dataset limpio;
- archivo del diccionario de variables;
- registro del proceso ejecutado.

## Dia 14. Revision de consistencia y cierre de semana
### Objetivo del dia
Validar la calidad final del dataset construido y cerrar la documentacion tecnica de la semana 2.

### Actividades
- Revisar consistencia del dataset:
  - columnas esperadas;
  - tipos de dato;
  - volumen de registros;
  - distribucion basica;
  - presencia de errores evidentes.
- Verificar que las variables derivadas se calcularon correctamente.
- Confirmar que el dataset puede ser utilizado en modelado offline.
- Redactar cierre tecnico de la semana 2.
- Identificar ajustes pendientes antes de iniciar la fase de modelado.

### Salida esperada
- validacion de consistencia del dataset;
- documentacion de cierre de semana 2.

### Evidencia a conservar
- resumen de consistencia;
- lista de ajustes pendientes;
- aprobacion tecnica para avanzar a modelado.

## 12. Matriz resumida de control semanal
| Dia | Enfoque principal | Resultado minimo esperado |
|---|---|---|
| 8 | Esquema y unidad de analisis | Dataset tabular definido y decision por flujo documentada |
| 9 | Features base | Lista minima viable de variables base |
| 10 | Features derivadas | Variables derivadas definidas con formula y uso |
| 11 | Limpieza y transformacion | Reglas reproducibles de limpieza y codificacion |
| 12 | Particion temporal | Train, validation y test definidos sin fuga evidente |
| 13 | Dataset limpio | Primer dataset apto para modelado y diccionario version 1 |
| 14 | Consistencia y cierre | Dataset validado y documentacion semanal cerrada |

## 13. Riesgos tecnicos de la fase
### Riesgo 1. Esquema tabular sobredimensionado
Impacto:
- complejiza el MVP y dificulta el modelado inicial.

Mitigacion:
- priorizar solo las variables necesarias;
- dejar features avanzadas para iteraciones posteriores.

### Riesgo 2. Perdida de trazabilidad con la fuente original
Impacto:
- dificulta auditoria del dataset y defensa metodologica.

Mitigacion:
- mantener referencia al campo fuente;
- documentar origen y transformacion de cada variable.

### Riesgo 3. Limpieza inadecuada de outliers reales
Impacto:
- elimina senales utiles para la deteccion de anomalias.

Mitigacion:
- distinguir entre error de dato y comportamiento raro real;
- documentar cualquier exclusion agresiva.

### Riesgo 4. Fuga temporal entre entrenamiento y prueba
Impacto:
- sesga artificialmente los resultados del modelado.

Mitigacion:
- usar particion cronologica;
- revisar la secuencia real de eventos antes de separar conjuntos.

## 14. Dependencias hacia la siguiente fase
La Fase 3 solo debe iniciar si esta semana deja resuelto lo siguiente:
- parser o mecanismo reproducible de ingesta implementado;
- dataset tabular estable;
- features base y derivadas definidas;
- reglas de limpieza documentadas;
- particion temporal cerrada;
- dataset limpio exportable y reutilizable.

## 15. Indicadores de control de avance
Para controlar la ejecucion de esta fase se recomienda verificar, como minimo:
- existencia de parser funcional o procedimiento automatizable;
- numero de columnas finales del dataset;
- cantidad de variables base y derivadas adoptadas;
- porcentaje de registros nulos o descartados;
- consistencia de tipos de dato;
- existencia de train, validation y test definidos;
- disponibilidad del diccionario de variables.

## 16. Cierre tecnico de la fase
La Fase 2 convierte una captura util en un activo analitico utilizable. Es la fase donde la telemetria deja de ser solo evidencia de red y pasa a constituirse en dataset para machine learning. Si esta semana se ejecuta con rigor, la fase de modelado partira sobre datos comprensibles, trazables y defendibles. Si esta semana se ejecuta con debilidad, cualquier resultado posterior del modelo sera dificil de interpretar, reproducir o sostener metodologicamente. Por ello, esta fase debe tratarse como el puente critico entre la instrumentacion del laboratorio y la inteligencia predictiva del producto.