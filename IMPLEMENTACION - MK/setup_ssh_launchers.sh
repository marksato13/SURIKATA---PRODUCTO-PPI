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
