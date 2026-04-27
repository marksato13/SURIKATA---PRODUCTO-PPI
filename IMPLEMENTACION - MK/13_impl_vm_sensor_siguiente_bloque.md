# Siguiente bloque operativo de la VM sensor

## 1. Proposito del documento
Este documento define el siguiente bloque operativo despues de la preparacion base de la VM sensor / ML / control. Su objetivo es pasar de un entorno ya instalado a una fase de validacion real de captura, inspeccion de telemetria, preservacion de muestra inicial y preparacion del primer parser para transformar `eve.json` a un dataset tabular util para el MVP.

## 2. Estado actual ya validado
Hasta este punto, la VM sensor ya tiene evidencia suficiente de que su entorno base esta funcional. Se considera validado lo siguiente:
- Suricata instalado;
- Python `3.12.3` operativo;
- entorno `venv` funcional;
- librerias Python base instaladas correctamente;
- `eve.json` ya existe;
- `stats.log` ya existe.

Esto significa que la VM sensor ya no se encuentra en una etapa de instalacion inicial, sino en la transicion hacia validacion de captura y preparacion del dataset.

## 3. Que sigue ahora
El siguiente bloque real de trabajo sobre la VM sensor es el siguiente:
1. confirmar que Suricata esta capturando sobre `ens35`;
2. inspeccionar `eve.json`;
3. guardar una muestra inicial;
4. crear el primer parser;
5. transformar `eve.json` a dataset tabular;
6. empezar con features base.

## 4. Aclaracion tecnica sobre la version de Suricata
En esta instalacion, la consulta de version no se ejecuta con:

```bash
suricata --version
```

Sino con:

```bash
suricata -V
```

Esto es normal para la version instalada en esta VM y no representa un error.

## 5. Paso siguiente exacto en la VM sensor

## Paso 1. Ver version de Suricata correctamente
```bash
suricata -V
```

### Objetivo
Confirmar la version real operativa del sensor con la sintaxis correcta para esta instalacion.

## Paso 2. Confirmar que el proceso esta corriendo
```bash
ps aux | grep suricata
```

### Interpretacion
- Si el proceso aparece, Suricata sigue corriendo y no debe reiniciarse aun.
- Si no aparece, puede iniciarse manualmente con:

```bash
suricata -i ens35 -D
```

### Recomendacion
Si ya esta corriendo, no lo reinicies todavia. Primero inspecciona lo que ya esta produciendo.

## Paso 3. Ver eventos recientes en `eve.json`
```bash
tail -n 20 /var/log/suricata/eve.json
```

### Objetivo
Observar eventos reales recientes y validar que la telemetria sigue actualizandose.

## Paso 4. Filtrar tipos de evento presentes
```bash
jq -r '.event_type' /var/log/suricata/eve.json | sort | uniq -c
```

### Objetivo
Confirmar que clases de eventos esta generando Suricata en la practica.

### Lo que puede aparecer
- `flow`
- `alert`
- `stats`
- otros tipos segun configuracion y trafico observado

### Si `jq` no esta instalado
```bash
apt update && apt install -y jq
```

## Paso 5. Guardar una muestra inicial de trabajo
```bash
cp /var/log/suricata/eve.json /home/m4rk/ppi-sensor/data/raw/eve_inicial.json
```

### Verificar que se copio bien
```bash
ls -lh /home/m4rk/ppi-sensor/data/raw/
```

### Objetivo
Crear una copia base de trabajo para no depender unicamente del log vivo del sistema.

## Paso 6. Revisar si hay eventos `flow`
```bash
grep '"event_type":"flow"' /home/m4rk/ppi-sensor/data/raw/eve_inicial.json | head
```

### Objetivo
Confirmar que la muestra inicial contiene eventos de flujo, ya que la unidad analitica inicial del MVP sera por flujo.

### Interpretacion
- Si aparecen resultados, ya existe base tecnica para construir el primer parser.
- Si no aparecen resultados, debe revisarse si `flow` esta habilitado en `eve-log` o si el trafico observado aun no genero suficientes eventos de flujo.

## 6. Despues de eso: arranque del primer parser
Cuando ya se confirme que existen eventos `flow`, el siguiente paso sera crear el primer script parser dentro de:

```bash
/home/m4rk/ppi-sensor/scripts/
```

Nombre sugerido:
- `parse_eve_to_csv.py`

## 7. Trabajo esperado del parser
El primer parser debe encargarse de:
- leer `eve_inicial.json`;
- quedarse solo con eventos `flow`;
- extraer campos clave;
- generar un archivo CSV tabular.

## 8. Campos iniciales recomendados
La primera version del parser debe priorizar campos base suficientes para el MVP:
- `timestamp`
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

## 9. Secuencia practica real recomendada
Ejecutar exactamente en este orden:

```bash
suricata -V
ps aux | grep suricata
tail -n 20 /var/log/suricata/eve.json
jq -r '.event_type' /var/log/suricata/eve.json | sort | uniq -c
cp /var/log/suricata/eve.json /home/m4rk/ppi-sensor/data/raw/eve_inicial.json
ls -lh /home/m4rk/ppi-sensor/data/raw/
grep '"event_type":"flow"' /home/m4rk/ppi-sensor/data/raw/eve_inicial.json | head
```

## 10. Lo que debe confirmarse despues de esta secuencia
Una vez ejecutados los pasos anteriores, deben confirmarse estas tres condiciones:
1. si Suricata sigue activo;
2. que tipos de eventos aparecen en `eve.json`;
3. si ya existen eventos `flow` dentro de `eve_inicial.json`.

## 11. Valor tecnico de este bloque
Este bloque representa la transicion real entre preparacion de entorno y trabajo de datos. A partir de aqui, la VM sensor deja de ser solo una maquina instalada y pasa a convertirse en una fuente util de dataset para la Fase 2 del MVP.

## 12. Conclusiones tecnicas
Si este bloque se ejecuta correctamente y se confirma la existencia de eventos `flow`, entonces la VM sensor ya queda lista para iniciar el parser de `eve.json` y la construccion del primer dataset tabular del producto. Ese es el punto donde el proyecto empieza a moverse formalmente desde captura hacia analitica aplicada.
