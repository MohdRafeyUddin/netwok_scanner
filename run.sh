#!/bin/bash

echo "=============================================="
echo " Network Access Monitoring System"
echo "=============================================="
echo

# -----------------------------
# 1. Check for root (sudo)
# -----------------------------
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script with sudo:"
  echo "   sudo ./run.sh"
  exit 1
fi

# -----------------------------
# 2. Install required tools
# -----------------------------
echo "[*] Checking and installing required tools..."

if command -v apt >/dev/null 2>&1; then
    apt update -y
    apt install arp-scan nmap -y
elif command -v brew >/dev/null 2>&1; then
    brew install arp-scan nmap
else
    echo "❌ Unsupported OS."
    echo "   Please use Linux / Ubuntu / Kali / WSL."
    exit 1
fi

# -----------------------------
# 3. Ensure core script is executable
# -----------------------------
chmod +x network_monitor.sh

# -----------------------------
# 4. Ensure authorized devices file exists
# -----------------------------
if [ ! -f authorized_devices.csv ]; then
    echo "[*] authorized_devices.csv not found. Creating it..."
    echo "device_name,ip,mac" > authorized_devices.csv
fi

# -----------------------------
# 5. Run the main project
# -----------------------------
echo
echo "[*] Starting network scan..."
echo

./network_monitor.sh
