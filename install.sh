#!/bin/bash

# 🏗️  Installing AntiPhishX dependencies...

# Step 1: Install system dependencies for building packages
echo "✔️ Installing system dependencies..."
sudo apt-get update -y
sudo apt-get install -y build-essential python3-dev python3-pip python3-setuptools \
                        libatlas-base-dev libopenblas-dev liblapack-dev gfortran \
                        cython3

# Step 2: Install or update pip and setuptool
echo "✔️ Installing/updating pip and setuptools..."
pip install --upgrade pip setuptools

# Step 3: Create Python virtual environment
echo "📂 Creating a Python virtual environment..."
python3 -m venv myenv
source myenv/bin/activate

# Step 4: Install dependencies from requirements.txt
echo "📦 Installing Python dependencies..."
pip install --upgrade pip

# Install specific versions of dependencies
echo "✔️ Installing required dependencies..."
pip install pandas==1.5.3
pip install scikit-learn==1.2.2

# Optional: Install any other packages if needed
# pip install <other-required-packages>

# Verify installation
echo "✔️ Verifying installation..."
python -c "import pandas, sklearn; print('pandas:', pandas.__version__, 'scikit-learn:', sklearn.__version__)"

echo "🏗️  Installation complete!"
