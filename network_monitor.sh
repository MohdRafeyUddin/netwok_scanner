#!/bin/bash

# -----------------------------
# Auto-detect network
# -----------------------------
GATEWAY_IP=$(ip route | grep default | awk '{print $3}')
NETWORK=$(echo "$GATEWAY_IP" | sed 's/\.[0-9]*$/.0\/24/')

AUTHORIZED_FILE="authorized_devices.csv"
LOG_FILE="alerts.log"

echo "Scanning Network: $NETWORK"
echo
printf "%-15s %-20s %-45s %s\n" "IP Address" "MAC Address" "Vendor" "Status"
echo "---------------------------------------------------------------------------------------------------"

# -----------------------------
# Read authorized MAC addresses
# -----------------------------
AUTHORIZED_MACS=$(cut -d',' -f3 "$AUTHORIZED_FILE" | tail -n +2 | tr 'A-Z' 'a-z')

# -----------------------------
# Run arp-scan and parse output SAFELY
# -----------------------------
arp-scan -l | grep -E "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | while read -r line
do
    ip=$(echo "$line" | awk '{print $1}')
    mac=$(echo "$line" | awk '{print $2}')
    vendor=$(echo "$line" | cut -d$'\t' -f3-)

    mac_lower=$(echo "$mac" | tr 'A-Z' 'a-z')

    if echo "$AUTHORIZED_MACS" | grep -q "$mac_lower"; then
        status="AUTHORIZED"
    else
        status="UNAUTHORIZED ⚠️"
        time=$(date "+%Y-%m-%d %H:%M:%S")

        # Log unauthorized device WITH VENDOR NAME
        echo "$time | $ip | $mac | $vendor | Unauthorized device detected" >> "$LOG_FILE"

        echo
        echo "ALERT! Unauthorized device detected at $time"
    fi

    printf "%-15s %-20s %-45s %s\n" "$ip" "$mac" "$vendor" "$status"
done
