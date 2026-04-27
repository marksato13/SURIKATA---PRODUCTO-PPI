# Estructura del documento tecnico del MVP

## 1. Caratula
- Universidad
- Facultad
- Escuela profesional
- Titulo del documento
- Titulo del producto ingenieril
- Autor
- Asesor
- Lugar y fecha

## 2. Presentacion del documento
- Que es este documento
- Que version del producto describe
- Alcance: MVP de laboratorio

Texto sugerido:
Este documento presenta la implementacion tecnica inicial del producto ingenieril orientado a la deteccion temprana de comportamientos anomalos en redes de datos mediante modelos predictivos y un mecanismo de control inline. El alcance del documento corresponde a un MVP funcional en entorno de laboratorio.

## 3. Objetivo tecnico del MVP
- Implementar un flujo minimo funcional desde captura hasta accion
- Demostrar que el sistema puede:
  - capturar trafico
  - convertirlo en telemetria util
  - generar score de anomalia
  - decidir una accion
  - aplicar un control basico

## 4. Alcance del MVP
### Incluye
- captura con Suricata
- procesamiento de EVE JSON
- dataset tabular
- features base y derivadas minimas
- modelo `Isolation Forest`
- motor de decision por umbrales
- accion basica de permitir o bloquear
- validacion preliminar en laboratorio

### No incluye
- despliegue productivo
- arquitectura empresarial completa
- SIEM o Big Data como nucleo
- comparacion extensa de muchos modelos
- automatizacion multi-dominio

## 5. Arquitectura tecnica del MVP
Aqui debes poner directo la arquitectura real que implementaras.

### 5.1 Componentes
1. VM cliente
2. VM servidor
3. VM sensor / ML / control

### 5.2 Flujo tecnico
```text
Cliente -> Servidor
        -> trafico observado por Sensor
Sensor -> Suricata -> EVE JSON -> Python -> Features -> Isolation Forest
       -> Score -> Decision -> iptables/ipset
```

### 5.3 Rol de cada componente
- Cliente: genera trafico normal y anomalo
- Servidor: actua como destino del trafico
- Sensor: captura, analiza, decide y ejecuta accion

## 6. Topologia de laboratorio
- diagrama simple de 3 VMs
- red interna del laboratorio
- direccionamiento IP
- interfaces virtuales
- justificacion de no usar pfSense en esta etapa

Aqui puedes reutilizar:
- `topologia_inicial_laboratorio_sin_pfsense.md`
- `direccionamiento_ip_y_parametros_de_red_del_laboratorio.md`

## 7. Implementacion por fases
Esta es la parte central del documento. Aqui no expliques teoria larga. Explica que construiste en cada fase.

## 7.1 Fase 1. Preparacion tecnica y captura base
- entorno de laboratorio
- VMs creadas
- red configurada
- Suricata instalado
- EVE JSON validado
- primeras capturas de trafico normal y anomalo

Debes mostrar:
- que instalaste
- donde lo instalaste
- como verificaste que funcionaba
- que salida produjo

## 7.2 Fase 2. Ingesta, limpieza y feature engineering
- parser de EVE JSON
- estructura tabular del dataset
- variables base
- variables derivadas
- tratamiento de nulos, duplicados y codificacion
- particion train/validation/test

Debes mostrar:
- schema del dataset
- lista de features
- formulas usadas
- ejemplo de registro procesado

## 7.3 Fase 3. Modelado offline y seleccion del modelo
- por que usaste `Isolation Forest`
- baseline minimo usado o descartado
- configuracion inicial del modelo
- entrenamiento con trafico normal
- evaluacion con trafico mixto
- umbrales `t1` y `t2`

Debes mostrar:
- parametros del modelo
- criterio de seleccion
- metricas base
- latencia de inferencia

## 7.4 Fase 4. Motor de decision e integracion inline inicial
- logica de decision
- unidad de enforcement
- integracion con `iptables/ipset`
- prueba de bloqueo controlado
- opcion de `tc` para limitar si aplica

Debes mostrar:
- como traduces score a accion
- sobre que entidad aplicas la accion
- que regla se inserta o ejecuta
- que evidencia genero la prueba

## 7.5 Fase 5. Validacion inicial y cierre del MVP
- escenario normal sostenido
- escenario anomalo puntual
- escenario mixto simple
- observaciones operativas
- resultados preliminares
- backlog de junio

Debes mostrar:
- que si funciona
- que falla o falta
- que se ajustara despues

## 8. Estructura tecnica del software
Aqui ya bajas a implementacion real.

Propuesta minima:
```text
/data/raw
/data/processed
/scripts
/models
/results
/docs
```

Si quieres mas tecnico:
```text
/src/ingest
/src/features
/src/models
/src/decision
/src/enforcement
/src/evaluation
```

## 9. Herramientas usadas
- Suricata
- Python
- pandas
- numpy
- scikit-learn
- iptables
- ipset
- hping3
- tc, si aplica

No lo pongas como lista suelta. Ponlo con rol tecnico:
- herramienta
- funcion en el MVP
- justificacion breve

## 10. Parametros tecnicos del laboratorio
- VMs y recursos asignados
- CPU
- RAM
- disco
- interfaces
- red usada
- sistema operativo de cada VM

## 11. Escenarios de prueba del MVP
- trafico normal sostenido
- trafico anomalo puntual
- trafico mixto simple

Para cada uno:
- objetivo
- origen
- destino
- herramienta usada
- tiempo de ejecucion
- evidencia esperada

## 12. Resultados preliminares
- capturas logradas
- dataset generado
- modelo entrenado
- score observado
- accion ejecutada
- metricas preliminares

No necesitas vender resultados perfectos. Necesitas mostrar evidencia tecnica real.

## 13. Problemas encontrados y ajustes realizados
- problemas de captura
- problemas de datos
- problemas del modelo
- problemas de enforcement
- ajustes de umbrales

Esta seccion le da valor ingenieril al documento.

## 14. Limitaciones actuales del MVP
- no es productivo
- no esta optimizado a gran escala
- enforcement inicial simple
- comparacion de modelos limitada
- escenarios de prueba acotados

## 15. Trabajo siguiente
- mejorar validacion
- refinar features
- ajustar umbrales
- incorporar `limitar` con `tc`
- ampliar escenarios
- migrar a mejor hipervisor

## 16. Conclusiones tecnicas
Aqui debes cerrar con lenguaje directo:
- se implemento un MVP funcional
- se logro integrar captura, analitica, decision y accion
- el sistema es viable en laboratorio
- quedan ajustes para mejorar precision y estabilidad

## 17. Anexos
- comandos usados
- capturas de pantalla
- tablas de variables
- configuraciones de Suricata
- reglas de iptables
- resultados de pruebas

## 18. Orden simple para redactarlo
Si quieres escribirlo rapido, sigue este orden:
1. Caratula
2. Objetivo tecnico del MVP
3. Arquitectura tecnica
4. Topologia de laboratorio
5. Implementacion por fases
6. Estructura del software
7. Herramientas y parametros del laboratorio
8. Escenarios de prueba
9. Resultados preliminares
10. Problemas, limitaciones y siguientes pasos
11. Conclusiones
12. Anexos

## 19. Regla practica para no desviarte
Cada seccion debe responder una de estas preguntas:
- que implemente
- donde lo implemente
- con que herramienta
- como lo valide
- que evidencia produjo

Si una seccion no responde a eso, probablemente esta demasiado teorica para este documento.
