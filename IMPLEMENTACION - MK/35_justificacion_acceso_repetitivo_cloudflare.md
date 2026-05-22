# Justificacion del escenario de acceso repetitivo anomalo con base en Cloudflare Radar

## 1. Proposito del documento
Este documento justifica la inclusion del escenario de acceso repetitivo anomalo dentro del laboratorio del PPI usando como apoyo la perspectiva de seguridad en capa de aplicacion mostrada por Cloudflare Radar. Su objetivo es reforzar que no todos los comportamientos anómalos relevantes para la investigacion son floods de red puros, sino tambien patrones repetitivos sobre servicios de aplicacion que pueden afectar disponibilidad, rendimiento y comportamiento observable del flujo.

## 2. Punto de partida
Cloudflare Radar dedica una vista especifica a:

```text
Application Layer Security Worldwide
```

lo que indica que la actividad maliciosa relevante no solo se concentra en ataques volumetricos de capa 3/4, sino tambien en ataques y patrones de abuso dirigidos a la capa de aplicacion.

## 3. Que significa esto para el PPI
Para tu proyecto, esto refuerza una idea importante:

- no basta con modelar solo floods de red;
- tambien conviene modelar actividad anomala repetitiva sobre servicios expuestos;
- un servidor web o un servicio accesible puede sufrir degradacion o comportamiento anomalo sin necesidad de un DDoS hipervolumetrico.

En ese sentido, el escenario de acceso repetitivo anomalo se vuelve metodologicamente valido.

## 4. Que es el acceso repetitivo anomalo en tu laboratorio
En este PPI, el escenario de acceso repetitivo anomalo no debe entenderse como navegacion normal intensiva, sino como un patron abusivo de solicitudes repetidas o excesivas hacia un servicio expuesto, por ejemplo HTTP o SSH, desde una fuente controlada del laboratorio.

### Ejemplos en el laboratorio
- multiples peticiones HTTP seguidas y con poca pausa hacia `nginx`;
- secuencias repetidas de acceso a rutas del servidor;
- intentos repetidos de conexion o consulta que, sin ser un flood puro, generan un patron de abuso observable.

## 5. Por que este escenario es relevante
Este escenario aporta valor por varias razones:

1. introduce una anomalia menos explosiva que un flood clasico;
2. genera un patron anomalo de aplicacion observable en telemetria de flujo;
3. ayuda a entrenar y validar el modelo frente a comportamientos abusivos que no son solo volumetricos;
4. se alinea con la idea de amenazas sobre capa de aplicacion destacada por Cloudflare Radar.

## 6. Diferencia frente a trafico normal HTTP
No debe confundirse con el escenario `A1_http_normal`.

### Trafico normal HTTP
- solicitudes legitimas;
- pausas razonables;
- consumo de contenido esperado;
- patron de usuario.

### Acceso repetitivo anomalo
- solicitudes excesivas o muy repetidas;
- poca o ninguna pausa entre peticiones;
- patron mas mecanico o abusivo;
- mayor probabilidad de generar degradacion o comportamiento atipico.

## 7. Como se justifica tecnicamente
Si Cloudflare Radar separa la seguridad de capa de aplicacion como una categoria de observacion propia, entonces resulta coherente que un laboratorio de deteccion temprana incluya un escenario donde la anomalia se exprese en la interaccion repetitiva con el servicio, no solo en paquetes o floods puros.

Esto es especialmente importante para un producto como el tuyo, porque:
- Suricata puede ver los flujos y metadatos de esas sesiones;
- el parser y las features pueden reflejar repeticion, volumen y duracion;
- el modelo puede aprender que algunos patrones repetitivos son legitimos y otros no.

## 8. Ubicacion de este escenario dentro de tu plan
El acceso repetitivo anomalo encaja mejor dentro del grupo anomalo como escenario de abuso de servicio.

### Nombre sugerido
```text
B5_acceso_repetitivo_anomalo
```

### Valor para la data
- anomalia de aplicacion;
- variacion en cantidad de solicitudes;
- patron de abuso con menor volumen bruto que un flood puro.

## 9. Recomendacion de prioridad
Este escenario debe considerarse **obligatorio** dentro del grupo anomalo, porque complementa muy bien a:
- `B1_syn_flood`
- `B2_port_scan`
- `B3_udp_flood`

Mientras esos escenarios modelan floods y reconocimiento, este modela abuso repetitivo del servicio.

## 10. Conclusiones tecnicas
La referencia de Cloudflare Radar sobre seguridad en capa de aplicacion ayuda a justificar que tu laboratorio no debe limitarse a DDoS volumetrico. Incluir un escenario de acceso repetitivo anomalo fortalece el producto ingenieril, porque amplía el conjunto de patrones anómalos observables, mejora la diversidad del dataset y acerca el laboratorio a problemas reales de degradacion y abuso sobre servicios expuestos.
