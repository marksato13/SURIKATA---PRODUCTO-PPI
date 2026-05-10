# Planificacion refinada del Grupo A de trafico normal

## 1. Proposito del documento
Este documento consolida una version refinada del Grupo A de escenarios normales del laboratorio, orientada ya no solo a generar trafico legitimo, sino a producir una base de datos suficientemente util para el entrenamiento del modelo. Su objetivo es dejar claro cuales escenarios normales son obligatorios, cuales son complementarios y que ajustes conviene realizar para mejorar el valor del dataset.

## 2. Evaluacion general del Grupo A
El Grupo A esta bien planteado porque cubre distintas formas de trafico legitimo:
- navegacion web;
- administracion SSH;
- transferencia de archivos;
- trafico sostenido;
- trafico de rendimiento controlado.

Esto lo convierte en una base adecuada para construir la linea base de comportamiento normal del laboratorio.

## 3. Escenarios del Grupo A

| Escenario | Duracion por corrida | Repeticiones | Total aproximado | Prioridad |
|---|---:|---:|---:|---|
| A1. Navegacion HTTP simple | 10 min | 3 | 30 min | Alta |
| A2. Administracion SSH legitima | 8 min | 3 | 24 min | Alta |
| A3. Transferencia de archivos legitima | 10 min | 3 | 30 min | Alta |
| A4. Trafico de servicio sostenido | 15 min | 3 | 45 min | Alta |
| A5. Trafico de rendimiento controlado | 5 min | 2 | 10 min | Complementaria |

## 4. Interpretacion de la prioridad

## 4.1 Escenarios obligatorios para la linea base normal
Los escenarios que deben formar la base principal del dataset normal son:
- A1. Navegacion HTTP simple
- A2. Administracion SSH legitima
- A3. Transferencia de archivos legitima
- A4. Trafico de servicio sostenido

Estos cuatro escenarios aportan diversidad suficiente de sesiones, puertos, volumen, duracion y comportamiento temporal para que el modelo tenga una base normal mas realista y menos sesgada.

## 4.2 Escenario complementario
El escenario:
- A5. Trafico de rendimiento controlado

debe considerarse complementario y no nuclear. Su uso es valido para enriquecer el dataset con flujos de mayor volumen, pero no debe dominar la linea base normal.

## 5. Ajustes recomendados por escenario

## 5.1 A1. Navegacion HTTP simple
### Estado
Correcto como escenario base.

### Ajuste recomendado
No debe limitarse a una sola solicitud. Debe incluir:
- acceso a pagina principal;
- acceso a una segunda ruta como `info.html`;
- descarga de algun recurso o archivo;
- pausas entre solicitudes.

### Justificacion
Esto mejora la variabilidad de `flow`, `bytes` y `pkts`, y evita un patron demasiado artificial.

## 5.2 A2. Administracion SSH legitima
### Estado
Valido y necesario.

### Ajuste recomendado
Se recomienda fijar la duracion en `8 min` por corrida, en lugar de dejar el rango `5 a 8 min`.

### Justificacion
Una duracion fija facilita comparacion entre corridas y hace mas consistente la captura. La variabilidad debe venir del comportamiento interno del script, no de una duracion incierta.

## 5.3 A3. Transferencia de archivos legitima
### Estado
Muy importante para el dataset.

### Ajuste recomendado
Se recomienda fijar la duracion en `10 min` por corrida.

### Justificacion
Este escenario es especialmente util porque modifica:
- volumen de bytes;
- longitud del flujo;
- duracion de sesiones;
- patron de transferencia legitima.

## 5.4 A4. Trafico de servicio sostenido
### Estado
Valido y recomendable.

### Ajuste recomendado
Mantener `15 min` por corrida, pero definir mejor el comportamiento esperado:
- solicitudes periodicas al servidor;
- pausas controladas;
- combinacion de acciones simples y sostenidas.

### Justificacion
No debe quedar como un concepto ambiguo. Debe representar actividad legitima persistente y no solo eventos aislados.

## 5.5 A5. Trafico de rendimiento controlado
### Estado
Util, pero no central.

### Ajuste recomendado
Mantenerlo como opcional o complementario, con `5 min` por corrida y `2` repeticiones iniciales.

### Justificacion
`iperf3` puede enriquecer el dataset, pero tambien puede introducir un patron demasiado especifico de alto volumen. Por ello no debe reemplazar ni dominar la base normal principal.

## 6. Estructura final recomendada del Grupo A

## 6.1 Escenarios base
- A1. Navegacion HTTP simple
- A2. Administracion SSH legitima
- A3. Transferencia de archivos legitima
- A4. Trafico de servicio sostenido

## 6.2 Escenario de enriquecimiento
- A5. Trafico de rendimiento controlado

## 7. Duracion total estimada del Grupo A
### Base principal
- A1: 30 min
- A2: 24 min
- A3: 30 min
- A4: 45 min

Total base principal aproximado:

```text
129 minutos
```

### Con escenario complementario
- A5: 10 min adicionales

Total extendido aproximado:

```text
139 minutos
```

## 8. Conclusiones tecnicas
El Grupo A, con estos ajustes, queda suficientemente robusto para servir como base del comportamiento normal del laboratorio. La clave no esta solo en mantener los nombres de los escenarios, sino en fijar tiempos consistentes, definir mejor el comportamiento interno de cada script y separar con claridad los escenarios obligatorios de los complementarios. De esta manera, el trafico normal del laboratorio sera mas util para el entrenamiento del modelo y mas defendible metodologicamente dentro del producto ingenieril.
