# Aclaraciones tecnicas sobre Suricata y preguntas clave del MVP

## 1. Proposito del documento
Este documento resume aclaraciones tecnicas importantes sobre el papel de Suricata dentro del PPI y responde preguntas frecuentes que pueden generar confusiones durante la implementacion del MVP. Su objetivo es dejar claro que Suricata es un componente central del entorno, pero no constituye por si solo el producto ingenieril completo.

## 2. Que es Suricata dentro del proyecto
Suricata cumple en este proyecto el rol de:
- sensor de red;
- generador de telemetria estructurada;
- motor de inspeccion IDS/IPS;
- fuente principal de eventos `EVE JSON` para el pipeline analitico.

En otras palabras, Suricata observa y registra el comportamiento del trafico. El producto PPI toma esa telemetria y construye encima la capa de analitica predictiva, la capa de decision y la futura capa de control.

## 3. Suricata tiene interfaz grafica?
Suricata por si solo no ofrece una interfaz grafica completa tipo dashboard nativo para operar como si fuera un SIEM o una consola SOC integral.

Lo que si ofrece es:
- motor de inspeccion;
- salida de logs;
- `eve.json`;
- alertas;
- estadisticas;
- soporte IDS/IPS.

## 4. Entonces como se visualiza normalmente?
En muchos entornos, Suricata se complementa con herramientas externas para visualizacion, por ejemplo:
- Kibana / ELK;
- EveBox;
- Scirius;
- Security Onion;
- dashboards propios.

Para el MVP del PPI esto no es obligatorio. En esta etapa, lo importante es que Suricata genere telemetria util y verificable, no que exista una interfaz visual compleja.

## 5. Que si hace Suricata en este PPI
Dentro del MVP, Suricata sirve para:
- ver trafico de red en la interfaz definida;
- registrar eventos de flujo;
- producir metadatos utiles para dataset;
- generar `eve.json`;
- dar evidencia tecnica de lo que ocurre en la red del laboratorio.

## 6. Que no hace Suricata por si solo
Suricata por si solo no resuelve toda la propuesta del PPI. No hace automaticamente todo lo siguiente como producto final integrado:
- seleccion del modelo predictivo del proyecto;
- calculo del score segun la logica analitica propia del MVP;
- transformacion del score a politicas `permitir`, `limitar`, `bloquear` segun tu diseno;
- orquestacion completa del flujo de datos del proyecto;
- validacion metodologica del producto ingenieril.

## 7. Suricata reemplaza el modelo predictivo?
No.

Suricata y el modelo predictivo cumplen funciones diferentes:
- Suricata captura y registra.
- El modelo aprende patrones y estima anomalia.

Por tanto, Suricata no reemplaza al modelo `Isolation Forest` ni a la logica de decision del PPI. Mas bien, alimenta con datos al modelo.

## 8. Si Suricata ya detecta, entonces donde esta la novedad?
La novedad del PPI no esta en instalar Suricata. La novedad se ubica en la integracion de estos componentes en un solo flujo funcional:
1. captura de telemetria;
2. transformacion a dataset;
3. modelado predictivo;
4. score de anomalia;
5. motor de decision;
6. accion inline o cuasi inline en laboratorio.

Por ello, Suricata es un insumo tecnico importante, pero no agota por si solo la contribucion del producto ingenieril.

## 9. Debe usarse Suricata como IDS o como IPS en esta etapa?
Para el MVP inicial, lo recomendable es usar Suricata primero como sensor de observacion y fuente de telemetria. Una vez validada la captura, el procesamiento y el modelo, se avanza hacia la parte de control y enforcement.

Esto evita complejidad prematura y mantiene el foco del proyecto en la construccion del pipeline del producto.

## 10. Es obligatorio tener interfaz grafica en el MVP?
No.

Para el MVP del PPI, la prioridad esta en:
- funcionalidad tecnica;
- calidad de la telemetria;
- generacion del dataset;
- entrenamiento del modelo;
- trazabilidad de decisiones;
- evidencia reproducible.

La interfaz grafica puede venir despues como soporte visual, pero no es requisito para demostrar el valor central del producto.

## 11. Preguntas clave que conviene resolver ahora
Durante esta etapa, las preguntas tecnicas mas importantes no son visuales, sino funcionales:
1. Suricata esta viendo trafico en la interfaz correcta?
2. `eve.json` contiene eventos `flow` utiles?
3. La telemetria puede convertirse a un dataset tabular?
4. El modelo puede entrenarse con esos datos?
5. El score puede traducirse a acciones medibles?
6. Existe trazabilidad entre evento, score, decision y accion?

## 12. Riesgos de confusion conceptual
Es importante no confundir:
- Suricata = sensor;
con
- producto PPI = sistema completo de captura, analitica, decision y control.

Si se confunden ambos niveles, el proyecto puede parecer solo una instalacion de herramienta y no un producto ingenieril propio.

## 13. Conclusiones tecnicas
Suricata es una pieza necesaria y muy util para el laboratorio, pero no constituye la solucion completa del PPI. Su valor en el proyecto esta en capturar y estructurar telemetria de red para que el resto del pipeline pueda operar. La contribucion central del producto sigue estando en la integracion de modelo predictivo, decision operativa y control sobre el trafico en un MVP reproducible de laboratorio.
