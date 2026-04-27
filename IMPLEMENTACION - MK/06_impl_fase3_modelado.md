# Fase 3. Modelado offline y seleccion del modelo

## 1. Identificacion de la fase
- Proyecto: Deteccion temprana de comportamientos anomalos en redes de datos mediante modelos predictivos y un mecanismo de control inline.
- Fase: Fase 3. Modelado offline y seleccion del modelo.
- Periodo de ejecucion: Semana 3, del 15 al 21 de mayo.
- Naturaleza de la fase: analitica y comparativa.
- Dependencia: requiere la salida valida de la Fase 2, especialmente dataset limpio, particion temporal definida y diccionario de variables disponible.

## 2. Proposito de la fase
Esta fase tiene como finalidad entrenar y validar el modelo principal del producto en entorno offline, comparando una alternativa minima de referencia y estableciendo una primera configuracion tecnicamente defendible para integracion posterior. Su funcion es seleccionar un clasificador viable no solo por capacidad de deteccion, sino tambien por latencia de inferencia y compatibilidad con el objetivo de operacion casi en tiempo real.

## 3. Objetivo especifico
Entrenar y validar el modelo principal, dejando un primer clasificador listo para integracion, con umbrales preliminares y resultados base de metricas que permitan justificar su adopcion dentro del MVP del producto.

## 4. Resultados esperados
Al cierre de la semana, esta fase debe producir los siguientes resultados:
- modelo `Isolation Forest` entrenado y documentado;
- comparacion minima offline con un baseline adicional;
- comportamiento del score analizado sobre trafico normal, anomalo y mixto;
- umbrales preliminares `t1` y `t2` para decisiones operativas;
- resultados base de `Precision`, `Recall`, `F1` y `FPR`;
- medicion inicial de latencia de inferencia;
- seleccion documentada de la configuracion ganadora para integracion.

## 5. Entregables formales
Los entregables de la fase son los siguientes:
1. Configuracion de entrenamiento del modelo principal.
2. Modelo `Isolation Forest` entrenado.
3. Baseline comparativo minimo offline.
4. Tabla de resultados base de metricas.
5. Definicion preliminar de umbrales de decision.
6. Registro de latencia de inferencia.
7. Documento de seleccion de modelo y cierre tecnico de la semana 3.

## 6. Alcance de la fase
### Incluye
- definicion del baseline de modelado para el MVP;
- entrenamiento de `Isolation Forest`;
- evaluacion offline de scores;
- comparacion minima con `LOF` o `One-Class SVM`;
- calibracion preliminar de umbrales de decision;
- medicion de metricas de clasificacion;
- medicion de latencia de inferencia;
- seleccion final de configuracion para integracion.

### No incluye
- integracion inline;
- aplicacion de decisiones sobre trafico en vivo;
- ajuste fino de politicas operativas;
- evaluacion completa del sistema end-to-end;
- pruebas de laboratorio con enforcement activo.

## 7. Precondiciones tecnicas
Antes de ejecutar esta fase deben cumplirse las siguientes condiciones:
- disponibilidad del dataset limpio producido en la Fase 2;
- particion temporal de entrenamiento, validacion y prueba ya definida;
- features base y derivadas consolidadas;
- trazabilidad minima entre muestras normales y anomalias observadas;
- entorno de procesamiento disponible para entrenamiento y evaluacion offline.

## 8. Estrategia tecnica de la fase
### 8.1 Modelo principal
El modelo central de esta fase es `Isolation Forest`, por las siguientes razones:
1. es compatible con datos tabulares por flujo;
2. no depende de etiquetado exhaustivo para su entrenamiento base;
3. presenta baja complejidad operativa;
4. tiene mejor alineacion con un MVP orientado a baja latencia.

### 8.2 Baseline comparativo minimo
Para no ampliar innecesariamente el alcance de mayo, la comparacion debe limitarse a:
- `Isolation Forest`;
- `LOF` o `One-Class SVM` como baseline opcional.

Se recomienda evitar en esta fase modelos profundos o secuenciales que introduzcan mayor costo, mayor tiempo de ajuste y una complejidad no necesaria para el primer clasificador integrable.

### 8.3 Logica de seleccion
La seleccion del modelo no debe basarse solo en una metrica de clasificacion aislada. La configuracion ganadora debe justificarse por equilibrio entre:
- capacidad de separacion entre normal y anomalo;
- estabilidad de score;
- facilidad de umbralizacion;
- latencia de inferencia;
- viabilidad de integracion posterior.

## 9. Criterios de aceptacion de la fase
La fase se considerara satisfactoria si se cumplen los siguientes criterios:
1. `Isolation Forest` puede entrenarse correctamente con el dataset definido.
2. Existe al menos una comparacion minima offline con un baseline adicional.
3. La distribucion de score permite observar diferencia razonable entre trafico normal y trafico anomalo.
4. Se establecen umbrales preliminares `t1` y `t2` con criterio tecnico documentado.
5. Se calculan `Precision`, `Recall`, `F1` y `FPR` sobre el conjunto de evaluacion definido.
6. La latencia de inferencia es suficientemente baja para justificar uso casi en tiempo real.
7. Se selecciona una configuracion final lista para pasar a integracion.

## 10. Cronograma operativo diario

## Dia 15. Definicion del baseline de modelado
### Objetivo del dia
Establecer el alcance exacto de la comparacion offline y cerrar formalmente que modelo sera el eje principal del MVP.

### Actividades
- Definir baseline de modelado para mayo.
- Confirmar que el modelo principal sera `Isolation Forest`.
- Seleccionar un baseline comparativo opcional:
  - `LOF`, o
  - `One-Class SVM`.
- Justificar tecnicamente por que la comparacion se limitara a dos enfoques.
- Documentar el criterio de no abrir el alcance a modelos profundos en esta etapa.

### Salida esperada
- baseline de modelado definido y documentado.

### Evidencia a conservar
- nota tecnica de seleccion de modelos;
- justificacion metodologica del alcance comparativo.

## Dia 16. Entrenamiento de Isolation Forest
### Objetivo del dia
Entrenar el modelo principal con base en el trafico normal y obtener una primera configuracion funcional.

### Actividades
- Preparar subconjunto de entrenamiento segun la particion definida.
- Entrenar `Isolation Forest` usando el trafico normal como base principal.
- Ajustar hiperparametros iniciales del modelo.
- Registrar parametros utilizados, version de dataset y condiciones de entrenamiento.

### Parametros iniciales a documentar
- numero de estimadores;
- `max_samples`;
- `contamination` si se define explicitamente;
- semilla o criterio de reproducibilidad;
- subconjunto temporal empleado para entrenar.

### Salida esperada
- primera version entrenada de `Isolation Forest`.

### Evidencia a conservar
- configuracion del entrenamiento;
- serializacion del modelo si aplica;
- bitacora de parametros iniciales.

## Dia 17. Evaluacion de scores sobre trafico mixto
### Objetivo del dia
Analizar el comportamiento del score del modelo sobre trafico mixto y observar la capacidad inicial de separacion entre comportamiento normal y anomalo.

### Actividades
- Aplicar el modelo entrenado sobre subconjuntos de evaluacion y trafico mixto.
- Obtener scores por observacion.
- Revisar la distribucion de score en:
  - trafico normal;
  - trafico anomalo;
  - trafico mixto.
- Detectar solapamientos, dispersion excesiva o ausencia de separacion util.
- Repetir ajustes iniciales si la salida resulta inestable.

### Salida esperada
- analisis preliminar del comportamiento del score del modelo.

### Evidencia a conservar
- resumen de scores;
- graficos o tablas de distribucion si se generan;
- observaciones tecnicas de separacion entre clases.

## Dia 18. Definicion de umbrales preliminares
### Objetivo del dia
Traducir el score analitico del modelo en una logica operativa preliminar compatible con la futura integracion inline.

### Actividades
- Definir umbral preliminar `t1` para accion de limitar.
- Definir umbral preliminar `t2` para accion de bloquear.
- Evaluar la relacion entre score y severidad observada del trafico.
- Documentar criterio de umbralizacion adoptado.
- Verificar que la distancia entre `t1` y `t2` permita una politica gradual y no binaria abrupta.

### Lineamiento tecnico
Los umbrales de esta fase son preliminares. No deben considerarse finales ni operativos para produccion, sino valores iniciales para integracion y ajuste posterior en laboratorio.

### Salida esperada
- umbrales `t1` y `t2` definidos preliminarmente.

### Evidencia a conservar
- tabla de umbrales;
- justificacion tecnica del criterio de seleccion.

## Dia 19. Evaluacion de metricas offline
### Objetivo del dia
Medir el comportamiento del modelo sobre el conjunto de evaluacion y obtener una linea base cuantitativa del clasificador.

### Actividades
- Calcular metricas offline del modelo principal.
- Medir como minimo:
  - `Precision`;
  - `Recall`;
  - `F1`;
  - `FPR`.
- Ejecutar la misma evaluacion para el baseline comparativo si fue incluido.
- Consolidar los resultados en una tabla comparativa minima.

### Salida esperada
- tabla de resultados base de metricas offline.

### Evidencia a conservar
- matriz de resultados;
- nota metodologica sobre el conjunto de evaluacion utilizado.

## Dia 20. Medicion de latencia de inferencia
### Objetivo del dia
Verificar que el modelo seleccionado puede operar con tiempos de inferencia compatibles con uso casi en tiempo real.

### Actividades
- Medir la latencia de inferencia del modelo principal sobre lotes pequenos o muestras unitarias, segun la logica del pipeline.
- Registrar tiempo medio, dispersion y observaciones relevantes.
- Comparar si el baseline alternativo presenta ventajas o desventajas significativas en tiempo.
- Confirmar que la latencia observada es razonable para integracion posterior.

### Criterio tecnico
En esta semana no se evalua aun la latencia total del pipeline con enforcement, sino la latencia de inferencia del clasificador en entorno offline controlado.

### Salida esperada
- medicion inicial de latencia de inferencia.

### Evidencia a conservar
- resultados de tiempo por corrida o lote;
- observaciones tecnicas sobre viabilidad temporal.

## Dia 21. Seleccion de configuracion ganadora y cierre tecnico
### Objetivo del dia
Cerrar la semana con una decision documentada sobre la configuracion que avanzara a integracion inline.

### Actividades
- Comparar resultados del modelo principal y del baseline opcional.
- Seleccionar la configuracion ganadora con base en:
  - metricas de deteccion;
  - comportamiento del score;
  - facilidad de umbralizacion;
  - latencia de inferencia.
- Redactar cierre tecnico de la semana 3.
- Registrar pendientes o mejoras previas a la Fase 4.

### Salida esperada
- configuracion final seleccionada para integracion;
- documentacion de cierre de semana 3.

### Evidencia a conservar
- decision formal de seleccion;
- lista de parametros finales adoptados;
- pendientes tecnicos para integracion.

## 11. Matriz resumida de control semanal
| Dia | Enfoque principal | Resultado minimo esperado |
|---|---|---|
| 15 | Baseline de modelado | Alcance comparativo cerrado con `Isolation Forest` como eje |
| 16 | Entrenamiento principal | Primera version entrenada de `Isolation Forest` |
| 17 | Analisis de scores | Diferenciacion observable entre trafico normal y anomalo |
| 18 | Umbralizacion | Umbrales `t1` y `t2` definidos preliminarmente |
| 19 | Metricas offline | Tabla base de `Precision`, `Recall`, `F1` y `FPR` |
| 20 | Latencia de inferencia | Evidencia de viabilidad temporal para integracion |
| 21 | Seleccion final | Configuracion ganadora y cierre tecnico documentado |

## 12. Riesgos tecnicos de la fase
### Riesgo 1. El score no separa adecuadamente normal y anomalo
Impacto:
- dificulta definir umbrales utiles y reduce valor operativo del modelo.

Mitigacion:
- revisar features;
- ajustar hiperparametros iniciales;
- validar calidad del dataset y de la particion temporal.

### Riesgo 2. Baseline comparativo amplia demasiado el alcance
Impacto:
- retrasa la semana y reduce foco sobre el modelo integrable.

Mitigacion:
- limitar la comparacion a un solo baseline adicional;
- priorizar la seleccion practica sobre exhaustividad academica en esta etapa.

### Riesgo 3. Metricas aparentan buen resultado pero con fuga de informacion
Impacto:
- invalida la seleccion y sesga la evaluacion.

Mitigacion:
- respetar estrictamente la particion temporal;
- documentar conjuntos usados en cada corrida.

### Riesgo 4. Latencia de inferencia no es compatible con integracion
Impacto:
- compromete la viabilidad del producto como sistema de baja latencia.

Mitigacion:
- mantener `Isolation Forest` como opcion principal;
- evitar modelos pesados en esta fase;
- medir tiempo con rigor antes de pasar a integracion.

## 13. Dependencias hacia la siguiente fase
La Fase 4 solo debe iniciar si esta semana deja resuelto lo siguiente:
- modelo principal entrenado y reutilizable;
- baseline minimo comparado o descartado justificadamente;
- umbrales preliminares definidos;
- metricas base disponibles;
- latencia de inferencia medida;
- configuracion final seleccionada para integracion.

## 14. Indicadores de control de avance
Para controlar la ejecucion de esta fase se recomienda verificar, como minimo:
- cantidad de corridas de entrenamiento realizadas;
- numero de configuraciones evaluadas;
- disponibilidad de resultados de metricas por configuracion;
- diferencia observable de scores entre normal y anomalo;
- tiempo medio de inferencia;
- existencia de una decision formal de seleccion.

## 15. Cierre tecnico de la fase
La Fase 3 representa el punto de transicion entre el trabajo de datos y la construccion de inteligencia operativa del producto. Aqui se decide si el modelo elegido no solo detecta, sino si ademas puede convertirse en el nucleo practico de una futura decision inline. El valor de esta semana no radica en comparar muchos algoritmos, sino en identificar una configuracion suficientemente robusta, interpretable y rapida para sostener el MVP. Si esta fase se ejecuta con criterio, la integracion posterior se apoyara en una decision tecnica clara. Si esta fase queda ambigua, la Fase 4 heredara incertidumbre sobre el comportamiento del clasificador y sobre la validez de sus umbrales.