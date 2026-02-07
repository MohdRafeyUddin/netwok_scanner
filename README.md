# Network Access Monitoring and Device Detection System

## Overview
This project automatically detects devices connected to a local network, identifies their vendors, and flags unauthorized devices using ARP-based scanning.

## Features
- Automatic network detection
- Device discovery (IP & MAC)
- Vendor identification
- Whitelist-based authorization
- Real-time alerts and logging

## Requirements
- Linux / Ubuntu / Kali / WSL
- sudo privileges
- Internet connection (first run only)

## How to Run
```bash
git clone https://github.com/YOUR_USERNAME/network-access-monitor.git
cd network-access-monitor
chmod +x run.sh
sudo ./run.sh
