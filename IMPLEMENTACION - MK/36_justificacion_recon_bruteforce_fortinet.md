# Justificacion de escenarios de reconocimiento y brute force con base en Fortinet 2026

## 1. Proposito del documento
Este documento traduce a criterios de laboratorio los hallazgos del informe *2026 Global Threat Landscape Report* de FortiGuard Labs, con el fin de justificar la inclusion de escenarios de reconocimiento, acceso repetitivo y brute force controlado dentro del producto ingenieril.

Su objetivo es fortalecer metodologicamente la seleccion de escenarios asociados a:
- escaneo de puertos y servicios;
- abuso repetitivo de servicios expuestos;
- intentos de acceso por fuerza bruta o presion de autenticacion;
- patrones que anteceden o acompañan intentos de intrusión a escala.

## 2. Criterio general de uso de la fuente
El informe de Fortinet no se emplea para afirmar que el laboratorio replica literalmente el comportamiento global de actores reales. Se emplea para justificar que ciertos patrones observables siguen siendo:
- frecuentes;
- automatizados;
- operacionalmente relevantes;
- adecuados para un laboratorio de deteccion temprana.

## 3. Hallazgos relevantes del informe Fortinet

## 3.1 La reconnaissance opera a escala industrial
Fortinet reporta que en 2025 se observaron aproximadamente:
- 640 mil millones de eventos de reconocimiento;
- con una logica de escaneo continuo y automatizado;
- alineados con MITRE ATT&CK TA0043 Reconnaissance.

El informe resalta especificamente tecnicas como:
- `T1595 Active Scanning`
- `T1595.001 IP Block Scanning`
- `T1595.002 Vulnerability Scanning`
- `T1590 Victim Network Information Gathering`

### Implicacion para el PPI
Esto justifica que tu laboratorio incluya escenarios de:
- `port scan`;
- escaneo de subred;
- reconocimiento repetitivo de servicios expuestos.

## 3.2 Nmap se observa como herramienta consistente de reconocimiento
Fortinet menciona a `Nmap` como una herramienta fundacional para:
- escaneo de puertos;
- fingerprinting de servicios;
- identificacion de protocolos;
- ejecucion continua y no solo episodica.

### Implicacion para el PPI
Esto valida plenamente el uso de `nmap` en el escenario:

```text
B2_port_scan
```

como un patron realista y tecnicamente defendible de reconocimiento.

## 3.3 Brute force como pipeline de produccion
Fortinet enfatiza que el brute force ya no debe verse como un intento ruidoso y aislado, sino como una actividad:
- automatizada;
- optimizada;
- ejecutada a escala;
- orientada a servicios con alta probabilidad de conversion.

El informe destaca que las presiones de brute force se concentran especialmente sobre servicios como:
- SMB
- SSH
- RDP
- MySQL

### Implicacion para el PPI
Esto justifica incluir, aunque sea de forma controlada, un escenario de:

```text
B6_bruteforce_controlado
```

preferentemente contra `SSH`, por ser un servicio presente en tu laboratorio y metodologicamente manejable.

## 3.4 La combinacion reconnaissance + brute force es critica
Fortinet resalta que el encadenamiento:

```text
reconnaissance -> brute force -> exploit overlap
```

es una logica de correlacion operacional relevante.

### Implicacion para el PPI
Esto te ayuda a justificar no solo escenarios aislados, sino tambien secuencias o escenarios mixtos donde:
- primero se identifica el servicio;
- luego se ejecuta acceso repetitivo o presion de autenticacion.

## 4. Escenarios del laboratorio reforzados por Fortinet

## 4.1 Escenario B2. Port scan
### Justificacion
Fortinet confirma que el reconocimiento automatizado y continuo es una capa persistente del ataque moderno, y que `nmap` sigue siendo una herramienta clave para el escaneo y fingerprinting.

### Valor para la data
- multiples puertos distintos;
- cambios de patron en ventana corta;
- base clara para detectar `Network Service Discovery`.

## 4.2 Escenario B5. Acceso repetitivo anomalo
### Justificacion
Si reconnaissance identifica una oportunidad, el siguiente paso natural en muchos entornos industriales es presionar servicios expuestos mediante credenciales, accesos repetitivos o pruebas sucesivas. Aunque el informe trata principalmente el acceso a escala, en el laboratorio esto puede modelarse como comportamiento repetitivo abusivo sobre HTTP o SSH.

### Valor para la data
- anomalia menos explosiva que un flood puro;
- patron repetitivo observable en flujo;
- utilidad para distinguir trafico legitimo de acceso abusivo.

## 4.3 Escenario B6. Brute force controlado
### Justificacion
Fortinet respalda que servicios como `SSH` son objetivos frecuentes de intentos automatizados de acceso. Un escenario de fuerza bruta controlada sobre `SSH` es metodologicamente valido siempre que se limite su intensidad y tiempo para no desestabilizar el laboratorio.

### Valor para la data
- patron de autenticacion anomala;
- multiples intentos sobre el mismo servicio;
- complemento ideal de `B2_port_scan`.

## 5. Recomendaciones de diseño para estos escenarios

## 5.1 Port scan
### Recomendacion
- mantenerlo como escenario obligatorio;
- ejecutarlo con duracion corta;
- registrar claramente origen, destino y subred objetivo.

### Duracion sugerida
- 2 a 3 minutos por corrida.

## 5.2 Acceso repetitivo anomalo
### Recomendacion
- enfocarlo como abuso de servicio de capa de aplicacion o acceso repetitivo al servicio;
- no mezclarlo con navegacion normal sin bitacora clara.

### Duracion sugerida
- 3 a 5 minutos por corrida.

## 5.3 Brute force controlado
### Recomendacion
- usarlo como escenario complementario o segunda iteracion del grupo anomalo;
- aplicarlo sobre `SSH` del servidor `192.168.0.120`;
- limitar intentos y ventana temporal.

### Duracion sugerida
- 2 a 4 minutos por corrida;
- con umbral de intentos claramente documentado.

## 6. Escenarios obligatorios y complementarios tras Fortinet

## Obligatorios
- `B2_port_scan`
- `B5_acceso_repetitivo_anomalo`

## Complementario muy recomendable
- `B6_bruteforce_controlado`

## 7. Conclusiones tecnicas
La fuente de Fortinet fortalece especialmente la parte de reconocimiento y de abuso de credenciales/servicios expuestos. Mientras ENISA y Cloudflare justifican muy bien la inclusion de DDoS, Fortinet aporta una base muy util para defender que tu laboratorio tambien debe modelar:
- scanning continuo;
- acceso repetitivo sobre servicios;
- brute force controlado;

porque todos ellos forman parte de un mismo encadenamiento operativo dentro de amenazas industrializadas y automatizadas. Esto enriquece tu dataset y hace que el producto ingenieril no se limite a floods, sino que cubra patrones anómalos relevantes a nivel de flujo, autenticacion y servicio expuesto.
