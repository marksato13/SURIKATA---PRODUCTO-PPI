# Plan de tiempos por grupo y escenario

## 1. Proposito del documento
Este documento define los tiempos recomendados de ejecucion para cada grupo de escenarios y para cada escenario individual dentro del laboratorio del PPI. Su objetivo es dar una base temporal clara para la captura de datos, la organizacion de corridas y la futura automatizacion de scripts de trafico.

## 2. Objetivo tecnico
Establecer una duracion razonable, repetible y viable para:
- escenarios normales;
- escenarios anomalos;
- escenarios mixtos;
- numero de corridas por escenario;
- tiempo total aproximado de captura util.

## 3. Criterio general de duracion
Los tiempos no deben ser tan cortos que no generen suficientes `flow`, ni tan largos que dificulten la trazabilidad o vuelvan muy pesada la captura. Se recomienda trabajar con ventanas controladas, repetidas y documentadas.

## 4. Duracion por grupo de escenarios

## 4.1 Grupo A. Trafico normal
### Duracion total estimada del grupo
- 8 a 10 horas efectivas de trabajo distribuido en varias corridas.

### Objetivo del grupo
Construir una linea base suficiente del comportamiento legitimo del laboratorio para entrenar el modelo y diferenciarlo de patrones anómalos.

## 4.2 Grupo B. Trafico anomalo
### Duracion total estimada del grupo
- 3 a 4 horas efectivas de trabajo distribuido en corridas cortas y controladas.

### Objetivo del grupo
Introducir desviaciones claras, observables y etiquetables para ajustar el score, validar deteccion y probar umbrales.

## 4.3 Grupo C. Trafico mixto
### Duracion total estimada del grupo
- 4 a 5 horas efectivas de trabajo distribuido en corridas donde coexistan trafico legitimo y anomalo.

### Objetivo del grupo
Validar que el sistema puede distinguir comportamiento anomalo dentro de trafico legitimo concurrente, que es el caso mas cercano a la operacion real del producto.

## 5. Duracion por escenario

## 5.1 Grupo A. Trafico normal

| Escenario | Duracion por corrida | Repeticiones recomendadas | Total aproximado |
|---|---:|---:|---:|
| A1. Navegacion HTTP simple | 10 min | 3 | 30 min |
| A2. Administracion SSH legitima | 5 a 8 min | 3 | 15 a 24 min |
| A3. Transferencia de archivos legitima | 8 a 10 min | 3 | 24 a 30 min |
| A4. Trafico de servicio sostenido | 15 min | 3 | 45 min |
| A5. Trafico de rendimiento controlado | 5 min | 2 o 3 | 10 a 15 min |

### Observacion tecnica
Los escenarios A1 a A4 deben considerarse prioritarios. El escenario A5 puede usarse como complemento si se desea enriquecer el volumen de trafico legitimo.

## 5.2 Grupo B. Trafico anomalo

| Escenario | Duracion por corrida | Repeticiones recomendadas | Total aproximado |
|---|---:|---:|---:|
| B1. SYN flood controlado | 1 min | 3 | 3 min |
| B2. Port scan TCP SYN | 2 a 3 min | 3 | 6 a 9 min |
| B3. UDP flood controlado | 1 min | 3 | 3 min |
| B4. ICMP flood controlado | 1 min | 2 o 3 | 2 a 3 min |
| B5. Acceso repetitivo anomalo al servicio | 3 a 5 min | 3 | 9 a 15 min |

### Observacion tecnica
Los escenarios anomalos no necesitan ser largos. Su valor no esta en la duracion, sino en que produzcan una anomalia clara, medible y repetible.

## 5.3 Grupo C. Trafico mixto

| Escenario | Duracion por corrida | Repeticiones recomendadas | Total aproximado |
|---|---:|---:|---:|
| C1. HTTP legitimo + SYN flood | 10 min | 2 o 3 | 20 a 30 min |
| C2. SSH legitimo + port scan | 8 a 10 min | 2 o 3 | 16 a 30 min |
| C3. Descarga legitima + UDP flood | 8 a 10 min | 2 o 3 | 16 a 30 min |

### Distribucion recomendada en mixtos
En los escenarios mixtos, una forma util de distribuir el tiempo es:
- 3 a 5 min de trafico legitimo inicial;
- 1 a 2 min de trafico anomalo concurrente;
- 3 a 5 min de continuidad o arrastre para observar comportamiento posterior.

## 6. Escenarios prioritarios y opcionales

## 6.1 Escenarios obligatorios
### Grupo A
- A1. Navegacion HTTP simple
- A2. Administracion SSH legitima
- A3. Transferencia de archivos legitima
- A4. Trafico de servicio sostenido

### Grupo B
- B1. SYN flood controlado
- B2. Port scan TCP SYN
- B3. UDP flood controlado
- B5. Acceso repetitivo anomalo al servicio

### Grupo C
- C1. HTTP legitimo + SYN flood
- C2. SSH legitimo + port scan
- C3. Descarga legitima + UDP flood

## 6.2 Escenarios opcionales
- A5. Trafico de rendimiento controlado
- B4. ICMP flood controlado

## 7. Numero total de corridas recomendado

### Grupo A
4 escenarios x 3 corridas = 12 corridas

### Grupo B
4 escenarios x 3 corridas = 12 corridas

### Grupo C
3 escenarios x 2 corridas = 6 corridas

### Total recomendado
- 30 corridas

## 8. Regla de captura por escenario
Para cada escenario, no se recomienda capturar solo el tiempo exacto del trafico. Conviene agregar una ventana adicional para contexto.

### Recomendacion
- 1 a 2 minutos antes del escenario
- 1 a 2 minutos despues del escenario

### Ejemplo
Si el escenario dura 10 minutos, la ventana de captura util puede ser de 12 a 14 minutos.

## 9. Uso metodologico de los tiempos
Los tiempos definidos aqui deben servir para:
- nombrar los archivos de salida;
- etiquetar ventanas de datos;
- documentar la bitacora;
- construir el parser con referencia temporal;
- evitar mezclar trafico sin control.

## 10. Recomendacion operativa final
Para una implementacion seria de dos meses, no es necesario exagerar la duracion de los ataques ni multiplicar escenarios innecesarios. Lo que se necesita es un conjunto de corridas bien definidas, repetidas y documentadas. La repeticion controlada de escenarios claros es mas valiosa para el modelo que capturas largas y desordenadas.

## 11. Conclusiones tecnicas
Los tiempos propuestos equilibran viabilidad, calidad de captura y utilidad para el entrenamiento del modelo. Si sigues esta estructura temporal, obtendras suficiente volumen y diversidad de `flow` para construir un dataset serio, sin perder trazabilidad ni control experimental dentro del laboratorio.
