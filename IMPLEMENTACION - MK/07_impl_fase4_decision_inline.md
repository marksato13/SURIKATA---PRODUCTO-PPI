# Fase 4. Motor de decision e integracion inline inicial

## 1. Identificacion de la fase
- Proyecto: Deteccion temprana de comportamientos anomalos en redes de datos mediante modelos predictivos y un mecanismo de control inline.
- Fase: Fase 4. Motor de decision e integracion inline inicial.
- Periodo de ejecucion: Semana 4, del 22 al 28 de mayo.
- Naturaleza de la fase: integracion operativa y validacion inicial de enforcement.
- Dependencia: requiere la salida valida de la Fase 3, especialmente modelo seleccionado, umbrales preliminares y evidencia de latencia de inferencia aceptable.

## 2. Proposito de la fase
Esta fase tiene como finalidad conectar el resultado analitico del modelo con acciones operativas reales sobre el trafico de red. Su funcion es transformar el score de anomalia en un veredicto ejecutable, establecer la primera logica de enforcement del MVP y validar que el sistema puede intervenir en laboratorio con una latencia inicial razonable, sin perder trazabilidad entre score, decision y accion.

## 3. Objetivo especifico
Conectar el score del modelo con acciones operativas sobre el trafico, definiendo la logica de decision, la unidad de enforcement, una primera integracion con mecanismos de control y una validacion inicial de latencia operativa.

## 4. Resultados esperados
Al cierre de la semana, esta fase debe producir los siguientes resultados:
- politica formal de decision basada en umbrales;
- unidad de enforcement definida para el MVP;
- integracion minima funcional con `iptables/ipset`;
- primeras pruebas operativas de permitir y bloquear;
- evidencia inicial de comportamiento del trafico bajo enforcement;
- medicion preliminar de latencia de decision y de efectos colaterales iniciales;
- ajustes basicos de reglas y umbrales para continuidad.

## 5. Entregables formales
Los entregables de la fase son los siguientes:
1. Politica de decision documentada.
2. Definicion de la unidad de enforcement del MVP.
3. Diseno de integracion minima con `iptables/ipset`.
4. Evidencia de pruebas basicas de permitir/bloquear.
5. Registro de tiempos y comportamiento del trafico bajo accion.
6. Diseno preliminar del mecanismo de limitar, si el tiempo lo permite.
7. Documento de cierre tecnico de la semana 4.

## 6. Alcance de la fase
### Incluye
- formalizacion de la politica `permitir`, `limitar`, `bloquear`;
- definicion de la entidad sobre la que actuara el enforcement;
- integracion minima con `iptables/ipset`;
- validacion practica de bloqueo controlado en laboratorio;
- medicion inicial de latencia operativa;
- observacion preliminar de impacto sobre trafico legitimo;
- ajuste basico de umbrales y reglas.

### No incluye
- mecanismo de control inline final completamente estabilizado;
- politicas avanzadas multi-criterio;
- evaluacion experimental completa por escenarios;
- optimizacion fina de rendimiento;
- despliegue productivo o multi-entorno.

## 7. Precondiciones tecnicas
Antes de ejecutar esta fase deben cumplirse las siguientes condiciones:
- disponibilidad del modelo seleccionado y entrenado;
- existencia de umbrales preliminares `t1` y `t2`;
- entorno Linux con privilegios administrativos suficientes;
- acceso a herramientas de control de trafico del sistema;
- laboratorio aislado y controlado para pruebas de bloqueo;
- trazabilidad entre score del modelo, entidad observada y regla aplicada.

## 8. Estrategia tecnica de la fase
### 8.1 Politica de decision
La politica operativa inicial del MVP se estructura del siguiente modo:
- `score < t1 -> permitir`
- `t1 <= score < t2 -> limitar`
- `score >= t2 -> bloquear`

Esta politica se adopta para evitar decisiones binarias excesivamente agresivas desde la primera integracion y para permitir una evolucion gradual del enforcement.

### 8.2 Unidad de enforcement recomendada
Para el MVP se recomienda iniciar con enforcement por `IP origen temporal`, por las siguientes razones:
1. simplifica la implementacion inicial;
2. facilita el uso de `ipset` para listas dinamicas;
3. reduce complejidad frente a enforcement por flujo completo;
4. mantiene una relacion razonable entre observacion, decision y accion en laboratorio.

Otras opciones como flujo, puerto o combinaciones temporales quedan como posibles refinamientos posteriores.

### 8.3 Priorizacion de acciones
En esta fase se priorizan primero las acciones:
- permitir;
- bloquear.

La accion de limitar puede diseniarse como extension si el tiempo de la semana lo permite, idealmente mediante `tc` o una estrategia equivalente de shaping.

## 9. Criterios de aceptacion de la fase
La fase se considerara satisfactoria si se cumplen los siguientes criterios:
1. La politica de decision queda formalmente definida y documentada.
2. La unidad de enforcement queda cerrada para el MVP.
3. Existe una integracion minima funcional con `iptables/ipset`.
4. Se ejecuta al menos una prueba controlada de bloqueo con evidencia suficiente.
5. Se registran tiempos y comportamiento observable del trafico durante la accion.
6. Se dispone de una primera medicion de latencia operativa.
7. Se documentan efectos iniciales sobre trafico legitimo y posibles falsos bloqueos.
8. Se ajustan reglas y umbrales basicos antes del cierre semanal.

## 10. Cronograma operativo diario

## Dia 22. Definicion formal de la politica de decision
### Objetivo del dia
Traducir el comportamiento del modelo en una politica operativa clara, documentada y util para el enforcement inicial.

### Actividades
- Definir formalmente la politica de decision del MVP.
- Documentar el significado operativo de cada rango de score.
- Establecer la relacion entre score y accion:
  - `score < t1 -> permitir`
  - `t1 <= score < t2 -> limitar`
  - `score >= t2 -> bloquear`
- Revisar si la politica es coherente con el comportamiento observado del modelo en la Fase 3.
- Documentar que `t1` y `t2` siguen siendo umbrales iniciales sujetos a ajuste.

### Salida esperada
- politica de decision formalmente definida.

### Evidencia a conservar
- documento de politica de decision;
- version vigente de `t1` y `t2`.

## Dia 23. Definicion de la unidad de enforcement
### Objetivo del dia
Definir sobre que entidad concreta actuaran las reglas operativas del prototipo.

### Actividades
- Evaluar las opciones de enforcement:
  - IP origen;
  - flujo;
  - puerto;
  - combinacion temporal.
- Analizar simplicidad de implementacion, trazabilidad y riesgo operativo de cada opcion.
- Seleccionar la unidad inicial del MVP.
- Documentar la recomendacion de iniciar por `IP origen temporal`.

### Salida esperada
- unidad de enforcement definida y justificada.

### Evidencia a conservar
- matriz comparativa breve de opciones;
- decision documentada del mecanismo inicial de enforcement.

## Dia 24. Diseno de integracion minima con iptables/ipset
### Objetivo del dia
Diseñar el mecanismo tecnico mas simple y controlable para enlazar veredictos del motor con acciones de red en laboratorio.

### Actividades
- Diseñar integracion minima con `iptables/ipset`.
- Priorizar primero las acciones:
  - permitir;
  - bloquear.
- Definir flujo de accion esperado:
  - score;
  - decision;
  - insercion o retiro de entidad en regla o conjunto;
  - efecto observable sobre trafico.
- Documentar tiempo de vida de reglas o bloqueos temporales si aplica.

### Salida esperada
- diseno inicial de enforcement con `iptables/ipset`.

### Evidencia a conservar
- logica de integracion documentada;
- estructura de reglas prevista;
- criterios de expiracion o persistencia del bloqueo.

## Dia 25. Prueba de bloqueo controlado en laboratorio
### Objetivo del dia
Validar que la accion de bloqueo puede ejecutarse en condiciones controladas y que su efecto queda observable en el trafico del laboratorio.

### Actividades
- Ejecutar una prueba de bloqueo controlado en laboratorio.
- Registrar el contexto exacto de la prueba:
  - origen;
  - destino;
  - tiempo de inicio;
  - tiempo de fin;
  - entidad bloqueada.
- Observar el comportamiento del trafico antes, durante y despues del bloqueo.
- Verificar si la respuesta es coherente con la regla aplicada.

### Salida esperada
- primera prueba operativa de bloqueo validada.

### Evidencia a conservar
- registro de la prueba;
- tiempos medidos;
- observaciones del comportamiento de trafico;
- evidencia del efecto de la regla aplicada.

## Dia 26. Diseno preliminar del mecanismo de limitar
### Objetivo del dia
Explorar la accion de limitar como respuesta intermedia, siempre que el avance de la semana lo permita sin comprometer el MVP.

### Actividades
- Evaluar factibilidad de implementar `limitar` en esta semana.
- Diseñar preliminarmente el mecanismo de limitacion.
- Considerar preferentemente `tc` como opcion tecnica para shaping.
- Documentar condiciones en que la accion de limitar seria activada.
- Si no resulta viable implementarla en esta semana, dejarla especificada como pendiente controlado para iteracion posterior.

### Salida esperada
- diseno preliminar de la accion de limitar o decision justificada de postergacion.

### Evidencia a conservar
- nota tecnica sobre `tc` o mecanismo equivalente;
- criterio de viabilidad o postergacion.

## Dia 27. Medicion operativa inicial
### Objetivo del dia
Obtener las primeras mediciones del comportamiento operativo del sistema una vez conectada la decision con la accion.

### Actividades
- Medir latencia de decision desde score o veredicto hasta efecto operativo observable.
- Estimar impacto inicial sobre trafico legitimo.
- Registrar falsos bloqueos iniciales o casos de afectacion no deseada.
- Documentar cualquier degradacion, retraso o incoherencia observada.

### Metricas de esta jornada
- latencia de decision;
- impacto sobre trafico legitimo;
- falsos bloqueos iniciales.

### Salida esperada
- primera evaluacion operativa basica del enforcement.

### Evidencia a conservar
- tiempos registrados;
- incidencias de afectacion sobre trafico legitimo;
- observaciones de comportamiento anomalo del sistema.

## Dia 28. Ajuste basico de umbrales y cierre tecnico
### Objetivo del dia
Cerrar la semana consolidando ajustes basicos sobre la politica operativa y documentando la preparacion del sistema para una validacion mas estructurada.

### Actividades
- Ajustar umbrales y reglas basicas segun resultados de las pruebas.
- Corregir problemas simples de exceso o defecto de bloqueo.
- Consolidar la version vigente de la politica operativa del MVP.
- Redactar cierre tecnico de la semana 4.
- Registrar pendientes de refinamiento para la fase de validacion inicial.

### Salida esperada
- configuracion operativa basica ajustada;
- documentacion de cierre de semana 4.

### Evidencia a conservar
- version ajustada de reglas y umbrales;
- resumen tecnico de resultados de la semana;
- lista de pendientes para la siguiente fase.

## 11. Matriz resumida de control semanal
| Dia | Enfoque principal | Resultado minimo esperado |
|---|---|---|
| 22 | Politica de decision | Regla `permitir/limitar/bloquear` documentada |
| 23 | Unidad de enforcement | MVP definido sobre `IP origen temporal` o equivalente justificado |
| 24 | Integracion minima | Diseno funcional con `iptables/ipset` priorizando permitir/bloquear |
| 25 | Bloqueo controlado | Prueba operativa de bloqueo ejecutada y evidenciada |
| 26 | Accion de limitar | Diseno preliminar con `tc` o postergacion justificada |
| 27 | Medicion operativa | Latencia inicial e impacto sobre trafico legitimo registrados |
| 28 | Ajuste y cierre | Reglas basicas ajustadas y semana cerrada documentalmente |

## 12. Riesgos tecnicos de la fase
### Riesgo 1. Enforcement demasiado agresivo
Impacto:
- afecta trafico legitimo y compromete la estabilidad del laboratorio.

Mitigacion:
- iniciar con reglas conservadoras;
- limitar el alcance del enforcement;
- usar entorno aislado y pruebas escalonadas.

### Riesgo 2. Desconexion entre score y accion
Impacto:
- el sistema pierde trazabilidad y resulta dificil de depurar.

Mitigacion:
- mantener registro de score, decision y regla aplicada;
- adoptar una unidad de enforcement simple para el MVP.

### Riesgo 3. Latencia operativa mayor a la esperada
Impacto:
- reduce el valor del sistema para intervencion oportuna.

Mitigacion:
- mantener la integracion minima;
- priorizar permitir y bloquear antes que politicas mas complejas;
- medir antes de sofisticar el enforcement.

### Riesgo 4. La accion de limitar amplia demasiado el alcance
Impacto:
- retrasa el avance semanal y afecta la estabilidad del MVP.

Mitigacion:
- tratar `limitar` como extension condicionada al tiempo disponible;
- documentar formalmente si se posterga para la fase siguiente.

## 13. Dependencias hacia la siguiente fase
La fase siguiente solo debe iniciar si esta semana deja resuelto lo siguiente:
- politica de decision cerrada para el MVP;
- unidad de enforcement definida;
- integracion minima funcional con `iptables/ipset`;
- evidencia de pruebas basicas de bloqueo;
- medicion inicial de latencia operativa;
- version basica de reglas y umbrales ajustada.

## 14. Indicadores de control de avance
Para controlar la ejecucion de esta fase se recomienda verificar, como minimo:
- existencia de la politica de decision versionada;
- entidad seleccionada para enforcement;
- numero de pruebas de bloqueo ejecutadas;
- tiempo medio de decision y accion observado;
- numero de falsos bloqueos iniciales detectados;
- estado de la accion `limitar`: implementada, diseniada o pospuesta.

## 15. Cierre tecnico de la fase
La Fase 4 representa la primera transicion del producto desde una solucion analitica hacia una solucion operativa. Aqui el sistema deja de ser solo un clasificador y empieza a comportarse como un mecanismo de intervencion. Por ello, el criterio principal de esta semana no es complejidad funcional, sino control. El MVP debe demostrar que puede vincular un score con una accion concreta, medible y trazable. Si esta fase se ejecuta con disciplina, la siguiente etapa podra concentrarse en validacion y ajuste. Si esta fase se sobredimensiona, el sistema perdera estabilidad antes de consolidar su primer comportamiento inline defendible.