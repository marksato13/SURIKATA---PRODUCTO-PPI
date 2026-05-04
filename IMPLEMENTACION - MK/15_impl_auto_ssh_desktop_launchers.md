# Automatizacion de accesos SSH y lanzadores de escritorio en Ubuntu Desktop

## 1. Proposito del documento
Este documento describe la automatizacion completa para generar accesos SSH con un clic desde el escritorio del usuario `m4rk` en Ubuntu Desktop hacia varias VMs del laboratorio. La automatizacion crea scripts `.sh`, accesos `.desktop`, estructura de carpetas auxiliar y distribuye los lanzadores directamente en `Escritorio`.

## 2. Objetivo tecnico
Permitir que desde `/home/m4rk/Escritorio` existan lanzadores listos para abrir terminal y conectarse por SSH a las siguientes IPs del laboratorio:
- `192.168.0.100`
- `192.168.0.110`
- `192.168.0.120`
- `192.168.0.130`
- `192.168.0.140`

Todos los accesos usan el mismo usuario remoto:
- usuario: `m4rk`

Y la misma contrasena inicial del laboratorio:
- contrasena inicial: `cisco123`

## 3. Recomendacion de seguridad y operacion
Aunque la contrasena inicial sea `cisco123`, la automatizacion esta pensada para dejar el entorno funcionando con clave SSH y no con contrasena en texto plano. El usuario `m4rk` ingresara una sola vez durante `ssh-copy-id`, y luego los accesos del escritorio funcionaran sin pedir contrasena si la clave fue copiada correctamente.

## 4. Resultado esperado
Al finalizar la automatizacion, el usuario `m4rk` tendra en su escritorio los siguientes lanzadores:
- `ssh-192.168.0.100.desktop`
- `ssh-192.168.0.110.desktop`
- `ssh-192.168.0.120.desktop`
- `ssh-192.168.0.130.desktop`
- `ssh-192.168.0.140.desktop`

Cada lanzador abrira una terminal nueva y ejecutara la conexion SSH correspondiente.

## 5. Ruta de trabajo usada por la automatizacion
La automatizacion usara esta ruta auxiliar:

```bash
/home/m4rk/ppi-lab
```

Estructura creada:

```text
/home/m4rk/ppi-lab/
├── scripts/
└── desktop/
```

## 6. Script unico de automatizacion
Guarda este archivo como:

```bash
/home/m4rk/Escritorio/setup_ssh_launchers.sh
```

## 7. Contenido del script
```bash
#!/usr/bin/env bash

set -e

USER_NAME="m4rk"
USER_HOME="/home/m4rk"
BASE_DIR="$USER_HOME/ppi-lab"
SCRIPTS_DIR="$BASE_DIR/scripts"
DESKTOP_DIR="$BASE_DIR/desktop"
REAL_DESKTOP="$USER_HOME/Escritorio"

IPS=(
  "192.168.0.100"
  "192.168.0.110"
  "192.168.0.120"
  "192.168.0.130"
  "192.168.0.140"
)

echo "[1/8] Instalando herramientas base..."
sudo apt update
sudo apt install -y openssh-client tree

echo "[2/8] Creando estructura de trabajo..."
mkdir -p "$SCRIPTS_DIR"
mkdir -p "$DESKTOP_DIR"
mkdir -p "$REAL_DESKTOP"

echo "[3/8] Verificando o generando clave SSH..."
mkdir -p "$USER_HOME/.ssh"
chmod 700 "$USER_HOME/.ssh"

if [ ! -f "$USER_HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -f "$USER_HOME/.ssh/id_ed25519" -N ""
else
  echo "Clave SSH ya existente: $USER_HOME/.ssh/id_ed25519"
fi

echo "[4/8] Creando scripts .sh por IP..."
for ip in "${IPS[@]}"; do
  script_name="ssh_${ip//./_}.sh"
  script_path="$SCRIPTS_DIR/$script_name"

  cat > "$script_path" <<EOF
#!/usr/bin/env bash
gnome-terminal -- bash -c "ssh $USER_NAME@$ip; exec bash"
EOF

  chmod +x "$script_path"
done

echo "[5/8] Creando lanzadores .desktop..."
for ip in "${IPS[@]}"; do
  script_name="ssh_${ip//./_}.sh"
  launcher_name="ssh-$ip.desktop"
  launcher_path="$DESKTOP_DIR/$launcher_name"

  cat > "$launcher_path" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=SSH $ip
Comment=Conexion SSH a $ip
Exec=$SCRIPTS_DIR/$script_name
Icon=utilities-terminal
Terminal=false
Categories=Network;Utility;
EOF

  chmod +x "$launcher_path"
done

echo "[6/8] Copiando lanzadores al escritorio..."
for ip in "${IPS[@]}"; do
  launcher_name="ssh-$ip.desktop"
  cp "$DESKTOP_DIR/$launcher_name" "$REAL_DESKTOP/"
  chmod +x "$REAL_DESKTOP/$launcher_name"
done

echo "[7/8] Ajustando propietario y permisos..."
chown -R "$USER_NAME:$USER_NAME" "$BASE_DIR"
chown -R "$USER_NAME:$USER_NAME" "$REAL_DESKTOP"

echo "[8/8] Resumen final..."
tree "$BASE_DIR"
echo
echo "Lanzadores disponibles en: $REAL_DESKTOP"
ls -l "$REAL_DESKTOP" | grep 'ssh-'
echo
echo "IMPORTANTE:"
echo "Ahora copia tu clave publica a las VMs remotas con estos comandos:"
for ip in "${IPS[@]}"; do
  echo "ssh-copy-id -i $USER_HOME/.ssh/id_ed25519.pub $USER_NAME@$ip"
done
echo
echo "La primera vez te pedira la contrasena: cisco123"
echo "Despues de eso, los lanzadores del escritorio deberian entrar sin pedir contrasena."
```

## 8. Dar permisos al script principal
```bash
chmod +x /home/m4rk/Escritorio/setup_ssh_launchers.sh
```

## 9. Ejecutar la automatizacion
```bash
bash /home/m4rk/Escritorio/setup_ssh_launchers.sh
```

## 10. Paso obligatorio despues de la automatizacion
Despues de crear los lanzadores, debes copiar la clave publica a cada VM remota. Ejecuta esto como `m4rk`:

```bash
ssh-copy-id -i /home/m4rk/.ssh/id_ed25519.pub m4rk@192.168.0.100
ssh-copy-id -i /home/m4rk/.ssh/id_ed25519.pub m4rk@192.168.0.110
ssh-copy-id -i /home/m4rk/.ssh/id_ed25519.pub m4rk@192.168.0.120
ssh-copy-id -i /home/m4rk/.ssh/id_ed25519.pub m4rk@192.168.0.130
ssh-copy-id -i /home/m4rk/.ssh/id_ed25519.pub m4rk@192.168.0.140
```

La primera vez te pedira la contrasena:

```bash
cisco123
```

## 11. Verificacion manual antes del clic
Antes de usar los lanzadores del escritorio, prueba manualmente:

```bash
ssh m4rk@192.168.0.100
ssh m4rk@192.168.0.110
ssh m4rk@192.168.0.120
ssh m4rk@192.168.0.130
ssh m4rk@192.168.0.140
```

Si todas entran sin contrasena, entonces el doble clic ya funcionara correctamente.

## 12. Si Ubuntu bloquea el lanzador
Si al hacer doble clic Ubuntu no ejecuta el acceso:
- clic derecho sobre el archivo del escritorio;
- seleccionar `Permitir iniciar` o `Allow Launching`.

## 13. Archivos generados por la automatizacion
### En `/home/m4rk/ppi-lab/scripts`
- `ssh_192_168_0_100.sh`
- `ssh_192_168_0_110.sh`
- `ssh_192_168_0_120.sh`
- `ssh_192_168_0_130.sh`
- `ssh_192_168_0_140.sh`

### En `/home/m4rk/ppi-lab/desktop`
- `ssh-192.168.0.100.desktop`
- `ssh-192.168.0.110.desktop`
- `ssh-192.168.0.120.desktop`
- `ssh-192.168.0.130.desktop`
- `ssh-192.168.0.140.desktop`

### En `/home/m4rk/Escritorio`
- `ssh-192.168.0.100.desktop`
- `ssh-192.168.0.110.desktop`
- `ssh-192.168.0.120.desktop`
- `ssh-192.168.0.130.desktop`
- `ssh-192.168.0.140.desktop`

## 14. Recomendacion operativa final
El script principal automatiza casi todo, pero la conexion sin contrasena depende de que la clave publica sea copiada a cada host con `ssh-copy-id`. Esa parte no debe omitirse. Una vez hecho eso, el usuario `m4rk` podra ingresar con un clic desde el escritorio a cualquiera de las VMs definidas.
