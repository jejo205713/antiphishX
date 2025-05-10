# 🌍︎ AntiPhishX – Smart URL Classification & Threat Detection

AntiPhishX is a machine learning-powered tool designed to **detect malicious URLs** based on SSL certificate presence, DNS resolution, and other smart heuristics. Built for researchers, developers, and security enthusiasts.

---

## 🚀 Features

- ✅ Classifies URLs as `Safe` or `Malicious` using ML (Random Forest)
- 🔒 Features include:
  - SSL Certificate check
  - DNS resolution
  - Detection of suspicious domains (e.g., `loclx.io`, tunneling services)
- 🔄 Learns and updates with new URLs added by user
- 🧠 Built-in training and prediction logic
- 🌐 (Optional) Stores the dataset on the **blockchain + IPFS** for transparency and immutability

---

## 🛠️ Installation & Usage

### 1. Clone the repo

```bash
git clone https://github.com/jejo205713/antiphishX.git
cd antiphishX
```

### 2. Set up virtual environment

```bash
python3 -m venv myenv
source myenv/bin/activate
```

### 3. Install requirements

```bash
chmod +x install.sh
```
```
./install.sh
```

### 4. Run the CLI tool

```bash
python3 antiphishX.py
```

You will be prompted to enter a URL, and the system will classify it based on trained logic.

---

## 🌐 Advanced (Optional): Use IPFS + Ethereum Blockchain

> Only needed if you want to fetch the dataset from a decentralized source.

### IPFS Installation (if using local daemon)

```bash
sudo apt install ipfs
ipfs init
ipfs daemon
```

Or use a **public IPFS gateway** like [https://ipfs.io](https://ipfs.io) (preconfigured).

---

### Ethereum Blockchain Setup (optional)

- You need:
  - A Web3 provider like [Infura](https://infura.io)
  - A deployed smart contract that stores your dataset's IPFS CID
  - The `contract_address` and `contract_ABI.json`

### Fetching CSV from Blockchain + IPFS

```bash
python3 ipfs_blockchain_utils.py  # Fetches latest CSV from Ethereum
```

The script will:
- Connect to Ethereum
- Get the CID
- Download the CSV via IPFS
- Replace `url_dataset.csv`

---

## 🤖 How the Prediction Works

1. Loads trained ML model (Random Forest)
2. Extracts features from URL:
   - SSL cert validity
   - DNS availability
3. Predicts using trained model
4. Displays verdict: ✅ Safe or ⚠️ Malicious

If URL is unknown:
- Offers to add to dataset
- Retrains model automatically

---

## 📊 Example Output

```
📈 Model trained successfully! ✅
Accuracy: 1.0
Enter the URL to check: https://is.gd/OxCzlm

❓ The URL 'https://is.gd/OxCzlm' is not found in the dataset.
Would you like to add it to the database? (y/n):
⚠️ The URL 'https://is.gd/OxCzlm' is classified as: Malicious ⚠️
```

---

## 📌 Notes

- No blockchain/IPFS setup is required unless you want decentralized features.
- The script uses `ipfs.io/ipfs/<CID>` for public IPFS access (no installation needed).
- Blockchain is read-only; no private key or ETH required to fetch CID.

---

## 🤝 Credits

Developed by [@jejo205713](https://github.com/jejo205713)  
Part of the **knightofNULL** project – Bringing cybersecurity tools to life. 

** NullByte Team :
* 1.Jejo J
* 2.Sona Angel RA
* 3.Pavithra P
* 4.Devadharshan 
* 5.Ranjith
  
---

## 📜 License
This project is under a custom license that allows personal and educational use only. Public forks and redistribution are prohibited without permission.
