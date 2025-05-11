#!/bin/bash

echo "==== Welcome to AntiPhishX Setup ===="

# Prompt for IPFS installation
read -p "Do you want to install IPFS? (y/n): " install_ipfs
if [[ "$install_ipfs" == "y" ]]; then
  echo "[*] Installing IPFS..."
  wget https://dist.ipfs.io/go-ipfs/v0.18.1/go-ipfs_v0.18.1_linux-amd64.tar.gz -O ipfs.tar.gz
  if tar -xvzf ipfs.tar.gz; then
    cd go-ipfs
    sudo bash install.sh
    cd ..
    rm -rf go-ipfs ipfs.tar.gz
    echo "[+] IPFS Installed Successfully"
  else
    echo "[!] Failed to extract IPFS archive. Skipping IPFS installation."
  fi
else
  echo "[*] Skipping IPFS installation."
fi

# Check for Python version
PYTHON_VERSION=$(python3 --version | cut -d " " -f2)
echo "[*] Detected Python version: $PYTHON_VERSION"

if [[ "$PYTHON_VERSION" == 3.12* ]]; then
  echo "[!] Python 3.12 detected — some packages like scikit-learn may not support this."
  echo "[*] Installing Python 3.11..."
  sudo apt update
  sudo apt install -y python3.11 python3.11-venv python3.11-distutils

  echo "[*] Creating virtual environment with Python 3.11..."
  python3.11 -m venv venv
else
  echo "[*] Using default Python version for virtual environment..."
  python3 -m venv venv
fi

# Activate environment
source venv/bin/activate

# Upgrade pip & install requirements
echo "[*] Upgrading pip, setuptools, and wheel..."
pip install --upgrade pip setuptools wheel

# Attempt to install requirements.txt
echo "[*] Installing Python dependencies..."
if ! pip install -r requirements.txt; then
  echo "[!] Error installing dependencies, attempting workaround for scikit-learn..."

  # Try specific scikit-learn version
  pip install scikit-learn==1.3.2
fi

echo "[+] Setup Complete. Activate environment with: source venv/bin/activate"
