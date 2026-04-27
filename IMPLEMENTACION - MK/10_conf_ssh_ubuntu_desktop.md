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

## Comandos para crear la estructura de trabajo
Ejecuta estos comandos en la VM Ubuntu Desktop para crear la estructura base:

```bash
mkdir -p ~/ppi-lab/scripts
mkdir -p ~/ppi-lab/desktop
touch ~/ppi-lab/scripts/conectar_sensor.sh
touch ~/ppi-lab/scripts/conectar_servidor.sh
touch ~/ppi-lab/desktop/conectar-sensor.desktop
touch ~/ppi-lab/desktop/conectar-servidor.desktop
```

Si quieres verificar que quedo correctamente creada:

```bash
tree ~/ppi-lab
```

Si no tienes `tree` instalado, puedes instalarlo con:

```bash
sudo apt update
sudo apt install -y tree
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
cp /home/m4rk/ppi-lab/desktop/conectar-sensor.desktop /home/m4rk/Escritorio/
cp /home/m4rk/ppi-lab/desktop/conectar-servidor.desktop /home/m4rk/Escritorio/
chmod +x /home/m4rk/Escritorio/conectar-sensor.desktop
chmod +x /home/m4rk/Escritorio/conectar-servidor.desktop
```

## Aclaracion sobre la carpeta Escritorio
En Ubuntu en espanol, la carpeta correcta del usuario suele ser:

```bash
/home/m4rk/Escritorio
```

Si estas trabajando como `root`, no conviene usar `~/Escritorio`, porque `~` apuntaria al home de `root` y no al home del usuario `m4rk`. Para evitar errores, en este escenario se recomienda usar siempre rutas completas.

## Si estas ejecutando comandos como root
Despues de crear o copiar archivos en el home del usuario `m4rk`, corrige propietario y permisos:

```bash
chown -R m4rk:m4rk /home/m4rk/ppi-lab
chown m4rk:m4rk /home/m4rk/Escritorio/conectar-sensor.desktop
chown m4rk:m4rk /home/m4rk/Escritorio/conectar-servidor.desktop
chmod +x /home/m4rk/Escritorio/conectar-sensor.desktop
chmod +x /home/m4rk/Escritorio/conectar-servidor.desktop
```

## Si por error creaste los archivos en `/root/ppi-lab`
Si ejecutaste los comandos como `root`, es posible que toda la estructura se haya creado en:

```bash
/root/ppi-lab
```

En ese caso, no debes copiar desde `/home/m4rk/ppi-lab` porque esa ruta aun no existira. Primero mueve o copia el contenido al home correcto del usuario `m4rk`.

### Verificar donde quedaron los archivos
```bash
ls -l /root/ppi-lab/scripts
ls -l /root/ppi-lab/desktop
```

### Crear la estructura correcta en el home de `m4rk`
```bash
mkdir -p /home/m4rk/ppi-lab/scripts
mkdir -p /home/m4rk/ppi-lab/desktop
```

### Copiar los archivos desde `/root/ppi-lab` hacia `/home/m4rk/ppi-lab`
```bash
cp /root/ppi-lab/scripts/conectar_sensor.sh /home/m4rk/ppi-lab/scripts/
cp /root/ppi-lab/scripts/conectar_servidor.sh /home/m4rk/ppi-lab/scripts/
cp /root/ppi-lab/desktop/conectar-sensor.desktop /home/m4rk/ppi-lab/desktop/
cp /root/ppi-lab/desktop/conectar-servidor.desktop /home/m4rk/ppi-lab/desktop/
chown -R m4rk:m4rk /home/m4rk/ppi-lab
```

### Copiar los accesos al escritorio del usuario
```bash
cp /home/m4rk/ppi-lab/desktop/conectar-sensor.desktop /home/m4rk/Escritorio/
cp /home/m4rk/ppi-lab/desktop/conectar-servidor.desktop /home/m4rk/Escritorio/
chown m4rk:m4rk /home/m4rk/Escritorio/conectar-sensor.desktop
chown m4rk:m4rk /home/m4rk/Escritorio/conectar-servidor.desktop
chmod +x /home/m4rk/Escritorio/conectar-sensor.desktop
chmod +x /home/m4rk/Escritorio/conectar-servidor.desktop
```

### Bloque completo listo para pegar si trabajaste como root
Si ya creaste los archivos bajo `/root/ppi-lab`, usa este bloque completo para moverlos al home correcto del usuario y dejarlos visibles en el escritorio:

```bash
ls -l /root/ppi-lab/desktop

mkdir -p /home/m4rk/ppi-lab/desktop
mkdir -p /home/m4rk/ppi-lab/scripts
mkdir -p /home/m4rk/Escritorio

cp /root/ppi-lab/desktop/conectar-sensor.desktop /home/m4rk/ppi-lab/desktop/
cp /root/ppi-lab/desktop/conectar-servidor.desktop /home/m4rk/ppi-lab/desktop/
cp /root/ppi-lab/scripts/conectar_sensor.sh /home/m4rk/ppi-lab/scripts/
cp /root/ppi-lab/scripts/conectar_servidor.sh /home/m4rk/ppi-lab/scripts/

chown -R m4rk:m4rk /home/m4rk/ppi-lab

cp /home/m4rk/ppi-lab/desktop/conectar-sensor.desktop /home/m4rk/Escritorio/
cp /home/m4rk/ppi-lab/desktop/conectar-servidor.desktop /home/m4rk/Escritorio/

chmod +x /home/m4rk/Escritorio/conectar-sensor.desktop
chmod +x /home/m4rk/Escritorio/conectar-servidor.desktop
chown m4rk:m4rk /home/m4rk/Escritorio/conectar-sensor.desktop
chown m4rk:m4rk /home/m4rk/Escritorio/conectar-servidor.desktop

ls -l /home/m4rk/Escritorio
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

## Conexion con un clic sin escribir contrasena
Si quieres entrar con un clic sin volver a escribir la contrasena en cada conexion, la opcion recomendada no es guardar `cisco123` en texto plano, sino configurar autenticacion por clave SSH.

## Opcion recomendada: clave SSH sin contrasena para laboratorio
Esta es la forma mas limpia para tu escenario.

### Paso 1. Generar una clave en la VM cliente
Ejecuta en `192.168.0.20` como usuario `m4rk`:

```bash
ssh-keygen -t ed25519 -f /home/m4rk/.ssh/id_ed25519 -N ""
```

Esto crea:
- clave privada: `/home/m4rk/.ssh/id_ed25519`
- clave publica: `/home/m4rk/.ssh/id_ed25519.pub`

### Paso 2. Copiar la clave publica al sensor
Si ejecutas el comando como el usuario `m4rk`:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub m4rk@192.168.0.110
```

Si estas logueado como `root`, debes indicar la clave publica con ruta completa:

```bash
ssh-copy-id -i /home/m4rk/.ssh/id_ed25519.pub m4rk@192.168.0.110
```

### Paso 3. Copiar la clave publica al servidor
Si ejecutas el comando como el usuario `m4rk`:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub m4rk@192.168.0.120
```

Si estas logueado como `root`, debes indicar la clave publica con ruta completa:

```bash
ssh-copy-id -i /home/m4rk/.ssh/id_ed25519.pub m4rk@192.168.0.120
```

La primera vez te pedira la contrasena `cisco123`. Despues de eso, la clave quedara autorizada y ya no deberias volver a escribirla.

### Si aparece `No identities found`
Ese error suele ocurrir cuando ejecutas `ssh-copy-id` como `root` y la clave fue generada para el usuario `m4rk`. En ese caso, debes usar la opcion `-i` con la ruta explicita de la clave publica.

### Paso 4. Probar acceso sin contrasena
```bash
ssh m4rk@192.168.0.110
ssh m4rk@192.168.0.120
```

Si entra directamente, ya puedes usar los accesos `.desktop` con un clic.

## Ajuste recomendado en los scripts `.sh`
Una vez configurada la clave SSH, tus scripts pueden quedar asi:

### `conectar_sensor.sh`
```bash
#!/usr/bin/env bash
gnome-terminal -- bash -c "ssh m4rk@192.168.0.110; exec bash"
```

### `conectar_servidor.sh`
```bash
#!/usr/bin/env bash
gnome-terminal -- bash -c "ssh m4rk@192.168.0.120; exec bash"
```

## Condicion real para que el clic funcione sin contrasena
Para que al presionar el acceso `.desktop` o ejecutar el `.sh` entres directamente sin escribir `cisco123`, deben cumplirse estas condiciones:
1. la clave SSH ya fue generada en la VM cliente;
2. la clave publica ya fue copiada al sensor y al servidor;
3. la prueba manual con `ssh` ya entra sin pedir contrasena.

El acceso `.desktop` por si solo no elimina la contrasena. Solo abre el comando `ssh`. La autenticacion sin contrasena depende de que la clave SSH ya este correctamente instalada en las maquinas remotas.

## Prueba manual obligatoria antes del clic
Antes de probar el acceso directo, ejecuta manualmente desde la VM cliente:

```bash
ssh m4rk@192.168.0.110
ssh m4rk@192.168.0.120
```

### Interpretacion del resultado
- Si entra directo, el acceso con clic ya deberia funcionar sin contrasena.
- Si todavia pide `cisco123`, entonces la clave publica aun no quedo bien instalada en la VM remota.

## Flujo correcto resumido
```text
Generar clave SSH
-> Copiar clave publica con ssh-copy-id
-> Probar acceso manual sin contrasena
-> Usar .sh
-> Usar .desktop con un clic
```

## Orden correcto de implementacion
1. Generar la clave SSH en la VM cliente.
2. Copiar la clave publica a `192.168.0.110`.
3. Copiar la clave publica a `192.168.0.120`.
4. Confirmar que `ssh` entra sin contrasena a ambas VMs.
5. Recién despues usar los accesos `.desktop`.

## Opcion no recomendada: guardar la contrasena en comando
Existe la posibilidad de usar `sshpass`, por ejemplo:

```bash
sshpass -p 'cisco123' ssh m4rk@192.168.0.110
```

Pero no se recomienda porque:
- deja la contrasena expuesta en texto plano;
- es menos limpio para documentacion tecnica;
- es peor practica incluso en laboratorio.

## Recomendacion final para tu caso
Si ambas VMs usan la misma contrasena `cisco123`, aprovecha eso solo para el primer `ssh-copy-id` y luego trabaja con clave SSH. Asi tendras exactamente lo que quieres:
- un clic;
- sin escribir contrasena;
- de forma mas profesional y mas estable.
