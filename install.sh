#!/bin/bash

# This script installs all dependencies for the AntiPhishX project

echo "🏗️  Installing AntiPhishX dependencies..."

# --- Check for IPFS installation ---
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

# --- Python 3 Installation ---
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

# --- virtualenv Installation ---
if ! pip3 show virtualenv &> /dev/null
then
    echo "🚨 virtualenv not found. Installing virtualenv..."
    pip3 install virtualenv
    echo "✅ virtualenv installed."
else
    echo "✔️ virtualenv is already installed."
fi

# --- Create and Activate Virtual Environment ---
echo "📂 Creating a Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

# --- Generate requirements.txt if not exists ---
if [ ! -f "requirements.txt" ]; then
    echo "⚠️  requirements.txt not found. Creating one..."
    cat <<EOL > requirements.txt
pandas==1.5.3
scikit-learn==1.2.2
scipy==1.10.1
numpy==1.24.3
EOL
fi

# --- Install Python Dependencies ---
echo "📦 Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# --- IPFS Dataset Download ---
read -p "🔗 Please enter the IPFS hash for the dataset: " ipfs_hash
echo "📥 Downloading the dataset from IPFS..."
ipfs get $ipfs_hash -o url_dataset.csv

# --- Start IPFS Daemon ---
echo "🔄 Starting IPFS Daemon..."
ipfs daemon &

# --- Final Message ---
echo "✅ AntiPhishX setup is complete!"
echo "To run the script:"
echo "source venv/bin/activate"
echo "python antiphishx.py"

# --- Credits ---
echo ""
echo "## Credits"
echo "NullByte Team:"
echo "* 1. Jejo J"
echo "* 2. Sona Angel RA"
echo "* 3. Pavithra"
echo "* 4. Devadharshan SS"
echo "* 5. Ranjith"
