# Sincronizacion de tiempo en todas las VMs del laboratorio

## 1. Proposito del documento
Este documento describe como verificar y alinear el tiempo del sistema en todas las maquinas virtuales del laboratorio. Su objetivo es asegurar que Ubuntu Desktop, Kali, Windows, Suricata y el servidor mantengan una referencia temporal coherente para que los `timestamp` del `eve.json`, la bitacora, los escenarios y el dataset sean comparables y trazables.

## 2. Por que es importante sincronizar el tiempo
Si las VMs tienen horas distintas, aparecen problemas como:
- `timestamp` inconsistentes en `eve.json`;
- bitacoras que no coinciden con los eventos capturados;
- etiquetas mal asignadas por tiempo;
- dificultad para separar escenarios normales, anomalos y mixtos;
- errores en el analisis por ventanas temporales.

Por ello, la sincronizacion del tiempo no es un detalle menor, sino una condicion tecnica del experimento.

## 3. Recomendacion general
La recomendacion mas limpia para el laboratorio es:
- usar la misma zona horaria en todas las VMs;
- preferentemente configurar todas en `UTC`;
- activar sincronizacion automatica si el entorno lo permite;
- verificar la hora antes de ejecutar escenarios.

## 4. VMs que deben verificarse
Las maquinas que deben quedar alineadas son:
- Ubuntu Desktop `192.168.0.20`
- Kali `192.168.0.100`
- Suricata `192.168.0.110`
- Ubuntu Server `192.168.0.120`
- Windows `192.168.0.10` si participa en escenarios o trafico normal

## 5. Estrategia recomendada
### Opcion preferida
Configurar todas las VMs en:

```text
UTC
```

### Por que usar UTC
- evita confusion entre hora local y hora universal;
- facilita comparar logs entre sistemas;
- simplifica parser y dataset;
- mejora la trazabilidad tecnica del laboratorio.

## 6. Verificacion y configuracion en Ubuntu / Kali / Suricata / Ubuntu Server
En todas las VMs Linux puedes usar la misma logica.

## 6.1 Ver estado actual del tiempo
Ejecutar:

```bash
timedatectl
```

### Debes revisar
- `Local time`
- `Universal time`
- `Time zone`
- `System clock synchronized`

## 6.2 Configurar zona horaria en UTC
Ejecutar:

```bash
sudo timedatectl set-timezone UTC
```

## 6.3 Activar sincronizacion automatica NTP
Ejecutar:

```bash
sudo timedatectl set-ntp true
```

## 6.4 Verificar nuevamente
Ejecutar:

```bash
timedatectl
date
```

### Resultado esperado
La salida debe mostrar que:
- la zona horaria es `UTC`;
- la hora es coherente con las demas VMs;
- la sincronizacion esta habilitada si el sistema lo soporta.

## 7. Verificacion y configuracion en Windows
En Windows puedes revisar desde PowerShell o CMD.

## 7.1 Ver fecha y hora actual
Ejecutar en PowerShell:

```powershell
Get-Date
```

## 7.2 Ver zona horaria actual
Ejecutar:

```powershell
tzutil /g
```

## 7.3 Ver estado del servicio de tiempo
Ejecutar:

```powershell
w32tm /query /status
```

## 7.4 Forzar resincronizacion
Ejecutar:

```powershell
w32tm /resync
```

### Nota
Si Windows participa realmente como fuente de trafico normal o como actor de escenario, su tiempo debe quedar alineado con las demas VMs.

## 8. Orden recomendado de verificacion
Para no perderte, verifica en este orden:
1. Suricata
2. Ubuntu Desktop
3. Kali
4. Ubuntu Server
5. Windows

## 9. Comandos resumidos por Linux
En cada VM Linux ejecutar:

```bash
timedatectl
sudo timedatectl set-timezone UTC
sudo timedatectl set-ntp true
timedatectl
date
```

## 10. Comandos resumidos por Windows
En PowerShell ejecutar:

```powershell
Get-Date
tzutil /g
w32tm /query /status
w32tm /resync
```

## 11. Que debes confirmar antes de ejecutar escenarios
Antes de correr cualquier escenario, debes confirmar:
1. que todas las VMs usan la misma zona horaria;
2. que la hora sea razonablemente igual entre ellas;
3. que Suricata este generando `timestamp` coherentes;
4. que la bitacora del laboratorio use la misma referencia temporal.

## 12. Recomendacion para la bitacora
La bitacora de escenarios debe registrarse siguiendo el mismo criterio temporal que las VMs. Si usas `UTC`, la bitacora debe interpretarse tambien en `UTC`.

## 13. Problemas comunes

## 13.1 Una VM muestra hora distinta
Posibles causas:
- zona horaria diferente;
- sincronizacion NTP desactivada;
- reloj del sistema desalineado.

## 13.2 Los timestamps de eve.json no coinciden con la bitacora
Posibles causas:
- Suricata o la VM sensor tienen otra referencia temporal;
- registraste manualmente la bitacora con otra hora;
- alguna VM quedo sin sincronizar.

## 13.3 Windows no resincroniza
Posibles causas:
- servicio de tiempo detenido;
- restriccion de red;
- desajuste temporal del invitado respecto al host.

## 14. Conclusiones tecnicas
La sincronizacion temporal de las VMs es una condicion basica para que el laboratorio produzca datos defendibles. No se trata solo de tener internet o servicios funcionando, sino de que los eventos capturados, exportados y etiquetados esten referidos a un mismo marco temporal. Por eso, antes de ejecutar escenarios y generar el dataset de entrenamiento, todas las VMs deben quedar alineadas en tiempo, preferentemente bajo `UTC`.
