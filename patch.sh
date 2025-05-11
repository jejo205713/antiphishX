#!/bin/bash

echo "Creating virtual environment..."
python3 -m venv venv
source venv/bin/activate

echo "Upgrading pip..."
pip install --upgrade pip

echo "Installing required Python packages manually..."
pip install pandas scikit-learn

echo "Other modules like warnings, socket, ssl, urllib, and os are part of the Python standard library and need no installation."

echo "Skipping IPFS installation as requested."

echo "Setup complete!"
