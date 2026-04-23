# Fase 5. Validacion inicial y cierre de mayo

## 1. Identificacion de la fase
- Proyecto: Deteccion temprana de comportamientos anomalos en redes de datos mediante modelos predictivos y un mecanismo de control inline.
- Fase: Fase 5. Validacion inicial y cierre de mayo.
- Periodo de ejecucion: Semana 5, del 29 al 31 de mayo.
- Naturaleza de la fase: verificacion funcional, consolidacion de resultados y cierre mensual.
- Dependencia: requiere la salida valida de la Fase 4, especialmente politica de decision definida, integracion minima operativa y evidencia inicial de enforcement en laboratorio.

## 2. Proposito de la fase
Esta fase tiene como finalidad cerrar el mes de mayo con evidencia funcional del MVP, verificando su comportamiento en escenarios controlados basicos y consolidando una lectura tecnica honesta del avance alcanzado. Su funcion no es presentar una validacion exhaustiva del sistema final, sino demostrar que el prototipo ya completa el flujo minimo entre captura, analisis, decision y accion, y que existen resultados suficientes para sostener la continuidad del desarrollo en junio.

## 3. Objetivo especifico
Cerrar mayo con evidencia funcional del MVP, ejecutando pruebas controladas, registrando resultados preliminares y dejando una lista clara de continuidad tecnica para junio y una version resumida reutilizable en el PPI o la tesis.

## 4. Resultados esperados
Al cierre de la semana, esta fase debe producir los siguientes resultados:
- ejecucion documentada de escenarios funcionales basicos;
- evidencia de comportamiento estable del MVP sobre trafico normal sostenido;
- evidencia preliminar de respuesta frente a trafico anomalo puntual y trafico mixto simple;
- registro de metricas preliminares y observaciones operativas;
- consolidacion del estado real del prototipo al cierre de mayo;
- lista priorizada de pendientes y ajustes para junio;
- resumen tecnico apto para incorporacion en documentos academicos del proyecto.

## 5. Entregables formales
Los entregables de la fase son los siguientes:
1. Registro de pruebas ejecutadas en la semana 5.
2. Resultados preliminares del comportamiento del MVP.
3. Resumen de estabilidad e impacto sobre trafico legitimo.
4. Lista de hallazgos, limitaciones y ajustes pendientes.
5. Plan de continuidad tecnica para junio.
6. Version resumida del avance de mayo para tesis o PPI.

## 6. Alcance de la fase
### Incluye
- ejecucion de escenarios funcionales controlados de cierre;
- observacion del comportamiento del MVP bajo trafico normal y anomalo simple;
- medicion preliminar de indicadores tecnicos relevantes;
- consolidacion del estado del prototipo al cierre de mayo;
- preparacion de un resumen tecnico reusable para documentacion academica.

### No incluye
- validacion experimental completa con las 40 corridas planeadas del estudio;
- ajuste fino definitivo de todos los umbrales;
- cierre metodologico total de la investigacion;
- despliegue productivo o extrapolacion a ambientes reales.

## 7. Precondiciones tecnicas
Antes de ejecutar esta fase deben cumplirse las siguientes condiciones:
- MVP operativo con flujo minimo entre score, decision y accion;
- entorno de laboratorio disponible y estable;
- escenarios de trafico controlado reproducibles;
- mecanismo de captura de evidencias activo;
- criterios basicos de observacion ya definidos para estabilidad, afectacion legitima y respuesta preliminar.

## 8. Enfoque tecnico de la fase
### 8.1 Criterio de validacion de mayo
La validacion de mayo debe entenderse como una validacion funcional inicial. El objetivo no es demostrar rendimiento final, sino responder con evidencia a tres preguntas:
1. El MVP se mantiene estable bajo trafico normal sostenido?
2. El MVP reacciona ante trafico anomalo simple de forma observable?
3. El equipo cuenta ya con base tecnica suficiente para continuar en junio con una validacion mas estructurada?

### 8.2 Logica de cierre mensual
La salida principal de esta fase es una fotografia tecnica del estado real del prototipo. Esa fotografia debe incluir:
- componentes que ya funcionan;
- componentes parcialmente implementados;
- riesgos aun abiertos;
- proximos pasos priorizados.

## 9. Criterios de aceptacion de la fase
La fase se considerara satisfactoria si se cumplen los siguientes criterios:
1. Se ejecuta al menos un escenario de trafico normal sostenido con evidencia de estabilidad.
2. Se ejecuta al menos un escenario de trafico anomalo puntual y uno mixto simple.
3. Se registran resultados preliminares del comportamiento del MVP.
4. Se identifican de manera explicita efectos sobre trafico legitimo, si los hubiera.
5. Se consolida una lista clara de ajustes y tareas para junio.
6. Se genera un resumen tecnico breve y reutilizable para documentos del proyecto.

## 10. Cronograma operativo diario

## Dia 29. Escenario de trafico normal sostenido
### Objetivo del dia
Confirmar que el MVP puede operar sobre un escenario normal sostenido sin generar degradacion significativa ni comportamiento erratico evidente.

### Actividades
- Ejecutar escenario de trafico normal sostenido.
- Observar el comportamiento general del prototipo durante la prueba.
- Verificar estabilidad del flujo de captura, analisis, decision y accion.
- Confirmar que el impacto sobre trafico legitimo se mantiene bajo o controlado.
- Registrar cualquier alerta inesperada, bloqueo indebido o latencia anomala.

### Salida esperada
- evidencia de estabilidad del MVP en condiciones normales controladas.

### Evidencia a conservar
- descripcion del escenario ejecutado;
- rango horario de prueba;
- observaciones de estabilidad;
- incidencias sobre trafico legitimo, si existieran.

## Dia 30. Escenarios de trafico anomalo puntual y trafico mixto simple
### Objetivo del dia
Verificar de forma preliminar que el MVP responde de manera observable ante eventos anómalos simples y ante convivencia de trafico normal con anomalo.

### Actividades
- Ejecutar escenario de trafico anomalo puntual.
- Ejecutar escenario de trafico mixto simple.
- Observar respuesta del sistema en terminos de score, decision y accion.
- Registrar metricas preliminares y observaciones operativas.
- Documentar diferencias de comportamiento entre escenario normal, anomalo puntual y mixto.

### Metricas preliminares sugeridas
- numero de acciones disparadas;
- latencia operativa observada;
- bloqueos correctos aparentes;
- bloqueos dudosos o falsos bloqueos iniciales;
- efecto visible sobre trafico legitimo.

### Salida esperada
- evidencia funcional preliminar del comportamiento del MVP frente a trafico anomalo y mixto.

### Evidencia a conservar
- descripcion de escenarios ejecutados;
- ventana temporal de cada prueba;
- metricas preliminares;
- observaciones del comportamiento del sistema.

## Dia 31. Consolidacion de resultados y cierre de mayo
### Objetivo del dia
Sintetizar tecnicamente lo construido en mayo, definiendo con claridad el estado actual del MVP y la ruta inmediata de continuidad hacia junio.

### Actividades
- Consolidar resultados del mes de mayo.
- Documentar explicitamente:
  - que si funciona;
  - que falta por implementar o refinar;
  - que se ajustara en junio.
- Organizar hallazgos en categorias:
  - captura y datos;
  - modelo;
  - motor de decision;
  - enforcement;
  - evaluacion.
- Preparar una version resumida y tecnica del avance para tesis o PPI.
- Dejar una lista priorizada de siguientes pasos para junio.

### Salida esperada
- cierre tecnico mensual;
- version resumida reutilizable en documento academico;
- backlog tecnico inicial para junio.

### Evidencia a conservar
- resumen ejecutivo-tecnico del mes;
- lista de pendientes priorizados;
- nota de continuidad para junio.

## 11. Matriz resumida de control semanal
| Dia | Enfoque principal | Resultado minimo esperado |
|---|---|---|
| 29 | Trafico normal sostenido | Evidencia de estabilidad y bajo impacto en condiciones normales |
| 30 | Trafico anomalo puntual y mixto | Evidencia funcional preliminar y metricas iniciales |
| 31 | Consolidacion y cierre | Estado real del MVP documentado y ruta clara para junio |

## 12. Riesgos tecnicos de la fase
### Riesgo 1. El MVP se comporta de forma inestable en trafico normal
Impacto:
- cuestiona la utilidad del sistema y dificulta continuar a validacion mas amplia.

Mitigacion:
- limitar alcance del escenario;
- documentar el problema con honestidad;
- ajustar umbrales y reglas conservadoras antes de repetir.

### Riesgo 2. Las pruebas anomalias no son lo bastante claras
Impacto:
- dificulta demostrar una respuesta preliminar observable.

Mitigacion:
- usar escenarios puntuales y bien trazados;
- registrar con precision el momento de inicio y fin;
- simplificar el escenario si la lectura es ambigua.

### Riesgo 3. Resultados preliminares se interpretan como resultados finales
Impacto:
- genera conclusiones metodologicamente incorrectas.

Mitigacion:
- documentar explicitamente que se trata de un cierre funcional de mayo;
- reservar la validacion completa para etapas posteriores.

### Riesgo 4. No se consolida una hoja de ruta clara para junio
Impacto:
- el proyecto pierde continuidad y foco en la siguiente etapa.

Mitigacion:
- cerrar mayo con backlog priorizado;
- separar claramente lo que ya esta logrado de lo que aun esta pendiente.

## 13. Dependencias hacia junio
El inicio de junio debe apoyarse en los siguientes insumos producidos en esta fase:
- pruebas funcionales documentadas;
- resultados preliminares del MVP;
- lista de problemas tecnicos detectados;
- prioridades de ajuste;
- resumen reutilizable para integracion en la documentacion del proyecto.

## 14. Indicadores de control de avance
Para controlar la ejecucion de esta fase se recomienda verificar, como minimo:
- numero de escenarios ejecutados;
- existencia de evidencia de estabilidad en trafico normal;
- numero de observaciones registradas en escenarios anomalos;
- disponibilidad de metricas preliminares;
- existencia de una lista priorizada de ajustes para junio;
- disponibilidad de un resumen tecnico breve del cierre mensual.

## 15. Estructura sugerida del cierre de mayo
Se recomienda que el resumen final del mes incluya como minimo los siguientes apartados:
1. Estado del entorno de laboratorio.
2. Estado de la captura y del dataset.
3. Estado del modelo y su configuracion actual.
4. Estado del motor de decision.
5. Estado del enforcement inline inicial.
6. Resultados funcionales preliminares.
7. Problemas abiertos y riesgos.
8. Prioridades tecnicas para junio.

## 16. Cierre tecnico de la fase
La Fase 5 cierra mayo con una validacion funcional inicial del MVP y cumple una funcion clave: transformar semanas de construccion tecnica en una evidencia consolidada de avance. Aunque los resultados de esta fase no sustituyen la validacion experimental completa del estudio, si permiten demostrar que el prototipo ya existe como sistema operativo basico y no solo como arquitectura teorica. El valor principal del cierre mensual radica en mostrar una linea de continuidad clara entre lo ya implementado y lo que sera refinado en junio. Si esta fase se documenta con precision y honestidad tecnica, el proyecto gana trazabilidad, credibilidad y direccion para la siguiente etapa de desarrollo.