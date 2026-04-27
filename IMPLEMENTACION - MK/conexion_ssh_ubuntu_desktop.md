# Conexion rapida desde Ubuntu Desktop a las VMs del laboratorio

## Objetivo
Permitir que desde la VM cliente Ubuntu Desktop puedas conectarte con un clic a:
- `192.168.0.110` -> VM sensor
- `192.168.0.120` -> VM servidor

## Recomendacion tecnica
Para Ubuntu Desktop, la opcion mas practica es usar:
1. un script `.sh` para abrir la conexion SSH;
2. un acceso directo `.desktop` para ejecutarlo con doble clic.

No necesitas un ejecutable binario. Con `.sh` + `.desktop` es suficiente, limpio y administrable.

## Requisito previo
En la VM cliente debe estar instalado `openssh-client`.

Comando:
```bash
sudo apt update
sudo apt install -y openssh-client
```

## Estructura sugerida en Ubuntu Desktop
```text
~/ppi-lab/
├── scripts/
│   ├── conectar_sensor.sh
│   └── conectar_servidor.sh
└── desktop/
    ├── conectar-sensor.desktop
    └── conectar-servidor.desktop
```

## Script para conectar al sensor
Archivo: `conectar_sensor.sh`

```bash
#!/usr/bin/env bash
gnome-terminal -- bash -c "ssh m4rk@192.168.0.110; exec bash"
```

## Script para conectar al servidor
Archivo: `conectar_servidor.sh`

```bash
#!/usr/bin/env bash
gnome-terminal -- bash -c "ssh m4rk@192.168.0.120; exec bash"
```

Si el usuario remoto no es `m4rk`, cambia el nombre por el usuario real de cada VM.

## Dar permisos de ejecucion
```bash
chmod +x ~/ppi-lab/scripts/conectar_sensor.sh
chmod +x ~/ppi-lab/scripts/conectar_servidor.sh
```

## Acceso directo para el sensor
Archivo: `conectar-sensor.desktop`

```ini
[Desktop Entry]
Version=1.0
Type=Application
Name=Conectar Sensor
Comment=SSH a 192.168.0.110
Exec=/home/m4rk/ppi-lab/scripts/conectar_sensor.sh
Icon=utilities-terminal
Terminal=false
Categories=Network;Utility;
```

## Acceso directo para el servidor
Archivo: `conectar-servidor.desktop`

```ini
[Desktop Entry]
Version=1.0
Type=Application
Name=Conectar Servidor
Comment=SSH a 192.168.0.120
Exec=/home/m4rk/ppi-lab/scripts/conectar_servidor.sh
Icon=utilities-terminal
Terminal=false
Categories=Network;Utility;
```

## Permisos para los accesos directos
```bash
chmod +x ~/ppi-lab/desktop/conectar-sensor.desktop
chmod +x ~/ppi-lab/desktop/conectar-servidor.desktop
```

## Copiarlos al escritorio
```bash
cp ~/ppi-lab/desktop/conectar-sensor.desktop ~/Desktop/
cp ~/ppi-lab/desktop/conectar-servidor.desktop ~/Desktop/
chmod +x ~/Desktop/conectar-sensor.desktop
chmod +x ~/Desktop/conectar-servidor.desktop
```

## Si Ubuntu bloquea el lanzador
Puede que Ubuntu marque el `.desktop` como no confiable. En ese caso:
- clic derecho en el archivo
- seleccionar `Allow Launching` o `Permitir iniciar`

## Opcion mas simple
Si no quieres accesos `.desktop`, solo usa los scripts:

```bash
bash ~/ppi-lab/scripts/conectar_sensor.sh
bash ~/ppi-lab/scripts/conectar_servidor.sh
```

## Recomendacion final
La mejor opcion para tu caso es:
- `.sh` para la logica de conexion
- `.desktop` para el clic directo en Ubuntu Desktop

Eso te da una solucion simple, reproducible y facil de modificar despues.
