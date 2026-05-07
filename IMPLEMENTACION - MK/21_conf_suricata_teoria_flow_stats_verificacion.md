# Suricata: teoria basica, significado de flow y stats, y verificacion para la investigacion

## 1. Proposito del documento
Este documento explica, en lenguaje tecnico y aplicado al PPI, que es Suricata, que significan los eventos `flow` y `stats`, por que son importantes para la investigacion y que comandos o rutas deben revisarse para verificar o ajustar la configuracion del sensor antes de continuar con la captura de escenarios del laboratorio.

## 2. Que es Suricata dentro de esta investigacion
Suricata es un motor IDS/IPS de red de codigo abierto que puede:
- observar trafico en una interfaz de red;
- inspeccionar paquetes y sesiones;
- generar eventos estructurados;
- producir alertas;
- exportar telemetria en formato `EVE JSON`.

Dentro de este PPI, Suricata no representa por si solo el producto completo. Su funcion principal es servir como:
- sensor de red;
- fuente de telemetria;
- base de observacion para construir el dataset del modelo predictivo.

## 3. Que papel cumple Suricata en el MVP
En el MVP del producto ingenieril, Suricata se utiliza para:
1. capturar trafico en la interfaz `ens35`;
2. transformar ese trafico en eventos estructurados;
3. almacenar esos eventos en `eve.json`;
4. permitir que Python los procese para construir dataset, features y modelos.

Por ello, Suricata no reemplaza al modelo `Isolation Forest`, sino que alimenta el pipeline analitico.

## 4. Que es EVE JSON
`EVE JSON` es el formato estructurado de salida de Suricata. En lugar de mostrar solo texto libre o alertas simples, Suricata puede escribir eventos detallados en formato JSON, lo que facilita:
- inspeccion automatica;
- parsing con Python;
- construccion de datasets;
- trazabilidad tecnica del trafico observado.

Ruta tipica del archivo en Ubuntu:

```bash
/var/log/suricata/eve.json
```

## 5. Que es un evento flow
Un evento `flow` representa informacion resumida de una comunicacion observada por Suricata. No describe un solo paquete aislado, sino el comportamiento agregado de un flujo o intercambio de red.

### Que suele contener un flow
Dependiendo de la configuracion y del trafico, puede incluir:
- `timestamp`
- `flow_id`
- `src_ip`
- `dest_ip`
- `src_port`
- `dest_port`
- `proto`
- `bytes_toserver`
- `bytes_toclient`
- `pkts_toserver`
- `pkts_toclient`
- `start`
- `end`
- `age`
- `state`

### Por que es importante para el PPI
Los eventos `flow` son la base mas util para:
- construir el dataset tabular;
- generar features base y derivadas;
- entrenar `Isolation Forest`;
- medir comportamiento normal y anomalo.

En otras palabras, para tu investigacion, `flow` es probablemente el tipo de evento mas importante del `eve.json`.

## 6. Que es un evento stats
Un evento `stats` contiene estadisticas del funcionamiento interno de Suricata. No describe un flujo concreto entre dos equipos, sino informacion global del motor de captura y analisis.

### Que suele contener stats
- tiempo de actividad (`uptime`)
- paquetes capturados
- paquetes descartados
- bytes totales vistos
- tipos de protocolo decodificados
- contadores internos del motor

### Por que aparece tanto en tu archivo
Porque Suricata genera estadisticas periodicamente. Si el trafico del laboratorio es aun pequeno, los eventos `stats` pueden dominar visualmente el archivo aunque si existan `flow`.

### Para que sirve stats en tu proyecto
`stats` no es el nucleo del dataset de modelado, pero si sirve para:
- verificar que Suricata esta funcionando;
- ver si realmente esta viendo paquetes;
- detectar si hay drops, errores o poca captura;
- apoyar validacion tecnica del sensor.

## 7. Diferencia practica entre flow y stats
| Tipo de evento | Que describe | Uso en tu PPI |
|---|---|---|
| `flow` | Comunicacion o flujo observado | Base del dataset y del modelado |
| `stats` | Estado y contadores del motor Suricata | Validacion del sensor y de la captura |

## 8. Que debes verificar para tu investigacion
Antes de avanzar a mas escenarios, debes confirmar al menos esto:
1. que Suricata esta corriendo;
2. que `eve.json` existe;
3. que `flow` esta habilitado en la salida `eve-log`;
4. que `stats` tambien aparece para validar el sensor;
5. que la interfaz correcta de captura es `ens35`;
6. que el archivo contiene suficientes eventos `flow` para construir dataset.

## 9. Rutas que debes revisar

## 9.1 Configuracion principal de Suricata
```bash
/etc/suricata/suricata.yaml
```

## 9.2 Carpeta de logs de Suricata
```bash
/var/log/suricata/
```

## 9.3 Archivo principal de telemetria
```bash
/var/log/suricata/eve.json
```

## 10. Comandos para verificar Suricata

### Ver version correcta
```bash
suricata -V
```

### Ver informacion de compilacion
```bash
suricata --build-info
```

### Confirmar que el proceso esta corriendo
```bash
ps aux | grep suricata
```

### Ver logs disponibles
```bash
sudo ls -lh /var/log/suricata/
```

### Ver las ultimas lineas de eve.json
```bash
sudo tail -n 20 /var/log/suricata/eve.json
```

### Ver eve.json en tiempo real
```bash
sudo tail -f /var/log/suricata/eve.json
```

## 11. Comandos para verificar flow y stats

### Ver tipos de evento presentes
```bash
jq -r '.event_type' /var/log/suricata/eve.json | sort | uniq -c
```

### Buscar eventos flow
```bash
grep '"event_type":"flow"' /var/log/suricata/eve.json | head
```

### Buscar eventos stats
```bash
grep '"event_type":"stats"' /var/log/suricata/eve.json | head
```

### Contar cuantos flow hay
```bash
grep -c '"event_type":"flow"' /var/log/suricata/eve.json
```

### Contar cuantos stats hay
```bash
grep -c '"event_type":"stats"' /var/log/suricata/eve.json
```

## 12. Como verificar la configuracion eve-log
Abre el archivo principal:

```bash
sudo nano /etc/suricata/suricata.yaml
```

Y revisa que exista una seccion similar a esta:

```yaml
- eve-log:
    enabled: yes
    filetype: regular
    filename: eve.json
    types:
      - alert
      - flow
      - stats
```

### Lo importante para tu investigacion
Debes confirmar que:
- `enabled: yes`
- `filename: eve.json`
- `types` incluye al menos:
  - `flow`
  - `alert`
  - `stats`

## 13. Como verificar la interfaz de captura
### Ver interfaces
```bash
ip a
```

### Confirmacion actual del laboratorio
La interfaz que estas usando para esta investigacion es:

```bash
ens35
```

### Si necesitas iniciar Suricata manualmente en esa interfaz
```bash
sudo suricata -i ens35 -D
```

## 14. Como validar la configuracion despues de cambios
Si modificas `suricata.yaml`, primero valida la sintaxis:

```bash
sudo suricata -T -c /etc/suricata/suricata.yaml
```

Si la validacion sale bien, reinicia Suricata:

```bash
sudo systemctl restart suricata
```

Si no usas servicio, puedes reiniciarlo manualmente:

```bash
sudo pkill suricata
sudo suricata -i ens35 -D
```

## 15. Cuando conviene cambiar la configuracion y cuando no

### Si debes ajustarla
Debes cambiar la configuracion si:
- `flow` no aparece;
- `eve.json` no se genera;
- la interfaz es incorrecta;
- no se ven suficientes eventos utiles;
- faltan tipos de salida necesarios para el MVP.

### No debes tocar demasiado si ya funciona
No hace falta reconfigurar Suricata de forma agresiva si:
- `eve.json` existe;
- `flow` aparece;
- `stats` aparece;
- la interfaz correcta esta activa;
- los campos minimos del dataset estan presentes.

En ese caso, basta con validar y continuar con captura de escenarios y parser.

## 16. Que conclusion sacar si flow y stats aparecen
Si aparecen ambos:
- `stats` te confirma que el sensor esta funcionando;
- `flow` te confirma que ya tienes base tecnica para tu dataset.

Eso significa que Suricata ya esta listo para servir como fuente de telemetria del producto ingenieril.

## 17. Conclusiones tecnicas
Para esta investigacion, `flow` es el evento mas importante porque alimenta el dataset del modelo predictivo. `stats` no reemplaza ese dataset, pero si es valioso para validar el estado del sensor y la calidad de la captura. La verificacion correcta de Suricata consiste en revisar la interfaz, el archivo `eve.json`, los tipos de evento presentes y la configuracion `eve-log` dentro de `suricata.yaml`. Si todo eso esta en orden, puedes continuar con confianza hacia el parser y la Fase 2 del MVP.
