# Fase 1. Preparacion tecnica y captura base

## 1. Identificacion de la fase
- Proyecto: Deteccion temprana de comportamientos anomalos en redes de datos mediante modelos predictivos y un mecanismo de control inline.
- Fase: Fase 1. Preparacion tecnica y captura base.
- Periodo de ejecucion: Semana 1, del 1 al 7 de mayo.
- Naturaleza de la fase: habilitadora e instrumental.
- Dependencia: inicio del producto; no requiere fases previas implementadas.

## 2. Proposito de la fase
Esta fase tiene como finalidad dejar operativo el entorno tecnico minimo del prototipo y obtener las primeras muestras de telemetria de red con trazabilidad suficiente para iniciar el procesamiento posterior. Su funcion es asegurar que el laboratorio, el sensor de captura, la estructura de trabajo y los primeros datos observables esten correctamente definidos antes de pasar a la etapa de preparacion de datos y modelado.

## 3. Objetivo especifico
Dejar listo el entorno de laboratorio y comenzar la captura de telemetria de red util, verificando que Suricata genere eventos validos en formato EVE JSON, que los escenarios iniciales de trafico normal y anomalo puedan reproducirse en el laboratorio y que las evidencias obtenidas sean suficientes para construir la base del dataset inicial.

## 4. Resultados esperados
Al cierre de la semana, esta fase debe producir los siguientes resultados:
- entorno de laboratorio definido y documentado;
- flujo de captura con Suricata funcionando correctamente;
- primeras muestras validas en formato EVE JSON;
- estructura inicial del proyecto organizada para datos, scripts, modelos, resultados y documentacion;
- evidencia basica de trafico normal y trafico anomalo simple;
- trazabilidad temporal suficiente para diferenciar eventos normales y anomalos.

## 5. Entregables formales
Los entregables de la fase son los siguientes:
1. Documento de definicion del entorno de laboratorio.
2. Evidencia de instalacion y validacion operativa de Suricata.
3. Primer conjunto de archivos EVE JSON con eventos observables.
4. Estructura de carpetas inicial del proyecto.
5. Registro de escenarios ejecutados durante la semana.
6. Bitacora tecnica de la semana 1 con hallazgos, decisiones y validaciones.

## 6. Alcance de la fase
### Incluye
- definicion del entorno donde se ejecutara el prototipo;
- verificacion de permisos y acceso administrativo;
- instalacion y validacion de Suricata;
- habilitacion de salida EVE JSON;
- captura inicial de trafico normal;
- generacion de trafico anomalo simple con hping3;
- separacion inicial de muestras normal/anomalo;
- documentacion tecnica de lo ejecutado.

### No incluye
- entrenamiento de modelos;
- feature engineering completo;
- comparacion de modelos;
- integracion inline con NFQUEUE o iptables;
- evaluacion cuantitativa final del sistema.

## 7. Precondiciones tecnicas
Antes de ejecutar esta fase deben cumplirse, como minimo, las siguientes condiciones:
- disponibilidad de una VM o servidor Linux para laboratorio;
- acceso administrativo con privilegios root o sudo;
- interfaz de red disponible para captura;
- entorno aislado o controlado, sin afectar trafico productivo;
- autorizacion de uso del laboratorio o del segmento de prueba;
- herramientas base instalables o ya instaladas: Suricata, hping3 y utilidades del sistema.

## 8. Componentes tecnicos involucrados
### Infraestructura
- VM Linux o servidor de laboratorio.
- Interfaz de red fisica o virtual.
- Segmento de prueba o topologia controlada.

### Software principal
- Suricata como sensor de red.
- hping3 como generador de trafico anomalo simple.
- Herramientas del sistema para validacion, lectura de logs y organizacion de archivos.

### Datos
- Telemetria de red en formato EVE JSON.
- Registros de tiempo de ejecucion de escenarios.

## 9. Criterios de aceptacion de la fase
La fase se considerara satisfactoria si se cumplen los siguientes criterios:
1. El entorno de laboratorio queda definido de forma explicita y documentada.
2. Suricata se instala y genera eventos en formato EVE JSON sin errores criticos.
3. Se obtienen muestras de trafico normal observables y almacenadas.
4. Se ejecuta al menos un escenario de trafico anomalo simple reproducible con evidencia asociada.
5. Los archivos de captura contienen campos minimos utiles para el proyecto.
6. La informacion recolectada puede separarse temporalmente entre normal y anomala.
7. La documentacion de la semana permite continuar hacia procesamiento de datos sin ambiguedad tecnica.

## 10. Cronograma operativo diario

## Dia 1. Confirmacion del entorno de ejecucion
### Objetivo del dia
Definir formalmente el entorno tecnico donde correra el prototipo y establecer la modalidad inicial de despliegue de Suricata.

### Actividades
- Confirmar la plataforma donde se ejecutara el prototipo:
  - VM Linux;
  - servidor de laboratorio;
  - entorno virtualizado o fisico.
- Verificar la interfaz de red disponible para captura.
- Confirmar permisos root, sudo o privilegios equivalentes.
- Documentar la topologia del laboratorio:
  - origen del trafico;
  - segmento observado;
  - equipo sensor;
  - ruta del trafico de prueba.
- Definir la modalidad inicial de despliegue de Suricata:
  - pasivo;
  - bridge;
  - inline de prueba.

### Salida esperada
- ficha tecnica del entorno de laboratorio;
- decision documentada sobre la modalidad de despliegue inicial de Suricata.

### Evidencia a conservar
- capturas de configuracion de red;
- nombre de interfaces;
- direccionamiento IP de laboratorio si aplica;
- nota tecnica sobre la topologia elegida.

## Dia 2. Instalacion y validacion de Suricata
### Objetivo del dia
Dejar Suricata operativo y confirmar que produce telemetria estructurada util para el proyecto.

### Actividades
- Instalar Suricata en el entorno Linux.
- Verificar que el servicio o ejecucion manual inicia sin errores criticos.
- Habilitar y revisar la salida EVE JSON.
- Confirmar que los eventos disponibles para esta fase incluyen como minimo:
  - flow;
  - alert;
  - stats, si aplica al escenario.
- Validar que Suricata escriba eventos en la ruta definida para captura.

### Salida esperada
- Suricata instalado y validado;
- generacion funcional de EVE JSON.

### Evidencia a conservar
- version instalada de Suricata;
- ruta del archivo `eve.json`;
- fragmentos de eventos generados;
- registro de configuracion basica usada.

## Dia 3. Estructura minima del proyecto y convenciones
### Objetivo del dia
Organizar el espacio de trabajo del producto para asegurar orden, trazabilidad y continuidad tecnica.

### Actividades
- Diseñar la estructura minima del proyecto con, al menos, las siguientes areas:
  - datos crudos;
  - datos procesados;
  - scripts;
  - modelos;
  - resultados;
  - docs.
- Establecer convencion de nombres para:
  - capturas;
  - escenarios;
  - corridas;
  - fechas;
  - versiones de pruebas.
- Documentar el criterio de almacenamiento de evidencias.

### Salida esperada
- estructura inicial del proyecto creada o definida formalmente;
- convencion de nombres estandar para archivos y ejecuciones.

### Evidencia a conservar
- arbol base de carpetas;
- archivo de convenciones o bitacora de organizacion.

## Dia 4. Captura de trafico normal de referencia
### Objetivo del dia
Obtener las primeras muestras de trafico normal y verificar la calidad de los campos tecnicos necesarios para el dataset inicial.

### Actividades
- Ejecutar captura de trafico normal de referencia en el laboratorio.
- Revisar calidad y consistencia de los eventos generados por Suricata.
- Confirmar presencia de campos clave, segun disponibilidad real del sensor:
  - `flow_id`;
  - `src_ip`;
  - `dest_ip`;
  - `src_port`;
  - `dest_port`;
  - `proto`;
  - campos de bytes;
  - campos de paquetes;
  - duracion del flujo.
- Registrar observaciones sobre datos faltantes, ruido o campos no utiles.

### Salida esperada
- primer conjunto de muestras de trafico normal;
- validacion de campos tecnicos minimos para procesamiento posterior.

### Evidencia a conservar
- archivo EVE JSON del trafico normal;
- tabla o nota de campos presentes;
- observaciones de calidad de datos.

## Dia 5. Generacion de trafico anomalo simple
### Objetivo del dia
Producir un escenario anomalo basico controlado y verificar que quede reflejado en la telemetria recolectada.

### Actividades
- Ejecutar trafico anomalo simple con hping3.
- Registrar exactamente:
  - fecha;
  - hora de inicio;
  - hora de fin;
  - tipo de escenario;
  - parametros principales usados.
- Capturar evidencia del trafico anomalo en Suricata.
- Comparar visualmente el comportamiento observado frente al trafico normal base.

### Salida esperada
- al menos un escenario anomalo simple ejecutado y documentado;
- evidencia de que el sensor registro el comportamiento inducido.

### Evidencia a conservar
- comando o configuracion de hping3 usada;
- rango horario del escenario;
- archivo EVE JSON asociado;
- nota tecnica de comportamiento observado.

## Dia 6. Separacion inicial de muestras y trazabilidad temporal
### Objetivo del dia
Organizar las muestras recolectadas y verificar que exista separacion temporal clara entre trafico normal y anomalo.

### Actividades
- Separar muestras iniciales en dos grupos:
  - normal;
  - anomalo.
- Verificar coherencia de timestamps en los eventos.
- Comprobar que los periodos de captura permiten trazar que escenario estaba ocurriendo en cada intervalo.
- Documentar cualquier desfase horario, perdida de eventos o inconsistencia temporal.

### Salida esperada
- muestras iniciales clasificadas por tipo de escenario;
- validacion de trazabilidad temporal para uso en fases posteriores.

### Evidencia a conservar
- relacion entre archivo y tipo de trafico;
- marcas de tiempo de referencia;
- bitacora de trazabilidad temporal.

## Dia 7. Cierre de semana y validacion de continuidad
### Objetivo del dia
Consolidar la documentacion de la semana y decidir formalmente si la captura obtenida es suficiente para pasar a la fase de procesamiento.

### Actividades
- Redactar cierre tecnico de la semana 1.
- Consolidar hallazgos, problemas encontrados y decisiones tomadas.
- Verificar si la captura cumple los criterios minimos para continuar a preparacion de datos.
- Identificar faltantes tecnicos que deban resolverse antes de la semana 2.

### Salida esperada
- informe de cierre de semana 1;
- decision tecnica de continuidad hacia procesamiento de datos.

### Evidencia a conservar
- resumen de entregables cumplidos;
- lista de pendientes tecnicos;
- validacion de suficiencia de captura.

## 11. Matriz resumida de control semanal
| Dia | Enfoque principal | Resultado minimo esperado |
|---|---|---|
| 1 | Entorno y topologia | Entorno definido y modalidad inicial de Suricata decidida |
| 2 | Instalacion de Suricata | EVE JSON generandose correctamente |
| 3 | Organizacion del proyecto | Estructura de trabajo y convenciones definidas |
| 4 | Trafico normal | Muestras base normales con campos clave validados |
| 5 | Trafico anomalo | Escenario anomalo simple ejecutado y evidenciado |
| 6 | Separacion y trazabilidad | Muestras iniciales separadas y tiempos consistentes |
| 7 | Cierre tecnico | Validacion de continuidad hacia la siguiente fase |

## 12. Riesgos tecnicos de la fase
### Riesgo 1. Falta de permisos o acceso de red
Impacto:
- impide captura real o configuracion del sensor.

Mitigacion:
- confirmar accesos antes del despliegue;
- documentar permisos requeridos;
- usar laboratorio controlado con privilegios suficientes.

### Riesgo 2. Suricata no genera eventos utiles
Impacto:
- imposibilita construir dataset base.

Mitigacion:
- validar configuracion de `eve.json` desde el inicio;
- comprobar tipos de evento habilitados;
- ejecutar pruebas cortas antes de capturas largas.

### Riesgo 3. Trafico anomalo no queda reflejado claramente
Impacto:
- dificulta diferenciar normalidad de anomalia.

Mitigacion:
- usar escenarios simples y controlados;
- registrar horarios exactos;
- repetir escenarios si la evidencia es insuficiente.

### Riesgo 4. Campos tecnicos incompletos o inconsistentes
Impacto:
- limita el feature engineering posterior.

Mitigacion:
- revisar campos minimos desde el dia 4;
- ajustar configuracion de captura si es necesario;
- documentar restricciones reales del dataset.

## 13. Dependencias hacia la siguiente fase
La fase siguiente solo debe iniciar si esta semana deja resuelto lo siguiente:
- telemetria disponible en EVE JSON;
- muestras normal y anomala separables;
- timestamps utilizables;
- campos minimos presentes para analisis tabular;
- estructura de proyecto lista para procesamiento.

## 14. Indicadores de control de avance
Para controlar la ejecucion de esta fase se recomienda verificar, como minimo:
- estado de instalacion de Suricata;
- disponibilidad de archivos EVE JSON;
- numero de capturas validas obtenidas;
- presencia de campos tecnicos minimos;
- existencia de al menos un escenario anomalo controlado documentado;
- grado de completitud de la bitacora tecnica semanal.

## 15. Cierre tecnico de la fase
La Fase 1 constituye la base operativa del producto de ingenieria. Su exito no depende de volumen de datos ni de complejidad analitica, sino de la calidad con la que se establezca el entorno, la captura y la trazabilidad inicial. Si esta fase queda bien ejecutada, las etapas posteriores de procesamiento, modelado y decision podran construirse sobre evidencia tecnica confiable. Si esta fase queda debil, el resto del pipeline se vuelve inestable metodologica y tecnicamente. Por ello, debe tratarse como una fase critica de habilitacion del prototipo y no como un paso menor de preparacion.
