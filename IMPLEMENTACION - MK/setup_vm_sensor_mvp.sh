#!/usr/bin/env bash

set -euo pipefail

USER_NAME="m4rk"
USER_HOME="/home/${USER_NAME}"
PROJECT_DIR="${USER_HOME}/ppi-sensor"
RAW_DIR="${PROJECT_DIR}/data/raw"
PROCESSED_DIR="${PROJECT_DIR}/data/processed"
MODELS_DIR="${PROJECT_DIR}/models"
SCRIPTS_DIR="${PROJECT_DIR}/scripts"
RESULTS_DIR="${PROJECT_DIR}/results"
DOCS_DIR="${PROJECT_DIR}/docs"
VENV_DIR="${PROJECT_DIR}/venv"
REPORT_FILE="${PROJECT_DIR}/docs/install_report_vm_sensor.txt"
INTERFACE="ens35"
CLIENT_IP="192.168.0.20"
SERVER_IP="192.168.0.120"

echo "[1/12] Actualizando sistema..."
apt update && apt upgrade -y

echo "[2/12] Instalando herramientas base..."
apt install -y net-tools curl wget jq tree git unzip vim tcpdump iptables ipset iproute2 python3 python3-pip python3-venv suricata

echo "[3/12] Creando estructura del proyecto..."
mkdir -p "${RAW_DIR}" "${PROCESSED_DIR}" "${MODELS_DIR}" "${SCRIPTS_DIR}" "${RESULTS_DIR}" "${DOCS_DIR}"

echo "[4/12] Creando entorno virtual..."
if [ ! -d "${VENV_DIR}" ]; then
  python3 -m venv "${VENV_DIR}"
fi

echo "[5/12] Instalando librerias Python del MVP..."
source "${VENV_DIR}/bin/activate"
pip install --upgrade pip
pip install pandas numpy scikit-learn matplotlib seaborn jupyterlab
pip freeze > "${PROJECT_DIR}/requirements.txt"
deactivate

echo "[6/12] Ajustando propietario del proyecto..."
chown -R "${USER_NAME}:${USER_NAME}" "${PROJECT_DIR}"

echo "[7/12] Verificando interfaz de captura..."
ip a show "${INTERFACE}" || true

echo "[8/12] Verificando conectividad del laboratorio..."
ping -c 4 "${CLIENT_IP}" || true
ping -c 4 "${SERVER_IP}" || true

echo "[9/12] Verificando version de Suricata..."
suricata -V || true
suricata --build-info || true

echo "[10/12] Iniciando Suricata sobre ${INTERFACE} si no esta corriendo..."
if ! pgrep -x suricata > /dev/null; then
  suricata -i "${INTERFACE}" -D
fi

echo "[11/12] Esperando generacion de logs..."
sleep 3
mkdir -p "${RAW_DIR}"
if [ -f /var/log/suricata/eve.json ]; then
  cp /var/log/suricata/eve.json "${RAW_DIR}/eve_inicial.json" || true
fi

echo "[12/12] Generando reporte de instalacion..."
{
  echo "REPORTE DE INSTALACION Y PREPARACION DE LA VM SENSOR"
  echo "Fecha: $(date)"
  echo
  echo "Usuario objetivo: ${USER_NAME}"
  echo "Proyecto: ${PROJECT_DIR}"
  echo "Interfaz de captura: ${INTERFACE}"
  echo "Cliente laboratorio: ${CLIENT_IP}"
  echo "Servidor laboratorio: ${SERVER_IP}"
  echo
  echo "=== VERSIONES ==="
  echo "Python:"
  python3 --version || true
  echo
  echo "Suricata:"
  suricata -V || true
  echo
  echo "=== PAQUETES INSTALADOS ==="
  dpkg -l | grep -E 'suricata|python3|python3-pip|python3-venv|net-tools|curl|wget|jq|tree|git|tcpdump|iptables|ipset|iproute2' || true
  echo
  echo "=== ESTRUCTURA DEL PROYECTO ==="
  tree "${PROJECT_DIR}" || true
  echo
  echo "=== ARCHIVOS DE LOG DE SURICATA ==="
  ls -l /var/log/suricata/ || true
  echo
  echo "=== TIPOS DE EVENTO EN eve.json ==="
  if [ -f /var/log/suricata/eve.json ]; then
    jq -r '.event_type' /var/log/suricata/eve.json | sort | uniq -c || true
  else
    echo "eve.json no encontrado"
  fi
  echo
  echo "=== MUESTRA INICIAL ==="
  ls -lh "${RAW_DIR}" || true
  echo
  echo "=== PROCESO SURICATA ==="
  ps aux | grep suricata || true
} > "${REPORT_FILE}"

chown -R "${USER_NAME}:${USER_NAME}" "${PROJECT_DIR}"

echo
echo "Preparacion base finalizada."
echo "Reporte generado en: ${REPORT_FILE}"
echo "Siguiente paso sugerido: revisar eventos flow y crear parse_eve_to_csv.py"
