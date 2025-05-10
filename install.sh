#!/bin/bash

# This script installs all dependencies for the AntiPhishX project

echo "🏗️  Installing AntiPhishX dependencies..."

# Check for IPFS installation
if ! command -v ipfs &> /dev/null
then
    echo "🚨 IPFS not found. Installing IPFS..."

    # IPFS Installation for Linux
    if [ "$(uname)" == "Linux" ]; then
        echo "💻 Installing IPFS on Linux..."
        curl -O https://dist.ipfs.io/go-ipfs/v0.14.0/go-ipfs_v0.14.0_linux-amd64.tar.gz
        tar -xvzf go-ipfs_v0.14.0_linux-amd64.tar.gz
        cd go-ipfs
        sudo bash install.sh
        cd ..
        rm -rf go-ipfs go-ipfs_v0.14.0_linux-amd64.tar.gz
    # IPFS Installation for macOS
    elif [ "$(uname)" == "Darwin" ]; then
        echo "💻 Installing IPFS on macOS..."
        brew install ipfs
    fi

    echo "✅ IPFS installation completed."
else
    echo "✔️ IPFS is already installed."
fi

# Install Python 3 if not already installed
if ! command -v python3 &> /dev/null
then
    echo "🚨 Python 3 not found. Installing Python 3..."
    if [ "$(uname)" == "Linux" ]; then
        sudo apt update
        sudo apt install python3 python3-pip -y
    elif [ "$(uname)" == "Darwin" ]; then
        brew install python3
    fi
    echo "✅ Python 3 installed."
else
    echo "✔️ Python 3 is already installed."
fi

# Install virtualenv if not installed
if ! pip3 show virtualenv &> /dev/null
then
    echo "🚨 virtualenv not found. Installing virtualenv..."
    pip3 install virtualenv
    echo "✅ virtualenv installed."
else
    echo "✔️ virtualenv is already installed."
fi

# Create virtual environment
echo "📂 Creating a Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies from requirements.txt
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt

# Prompt for IPFS hash and download dataset
read -p "🔗 Please enter the IPFS hash for the dataset: " ipfs_hash
echo "📥 Downloading the dataset from IPFS..."
ipfs get $ipfs_hash -o url_dataset.csv

# Inform user to start IPFS daemon
echo "🔄 Starting IPFS Daemon..."
ipfs daemon &

echo "✅ AntiPhishX setup is complete!"
echo "To run the script, activate the virtual environment and run the Python script:"
echo "source venv/bin/activate"
echo "python anitphishx.py"

# Credits
echo ""
echo "## Credits"
echo "NullByte Team :"
echo "* 1. Jejo J"
echo "* 2. Sona Angel RA"
echo "* 3. Pavithra"
echo "* 4. Devadharshan SS"
echo "* 5. Ranjith"
