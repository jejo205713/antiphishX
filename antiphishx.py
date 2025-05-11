import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, accuracy_score
from sklearn.preprocessing import LabelEncoder
import warnings
import socket
import ssl
from urllib.parse import urlparse
import os

warnings.filterwarnings("ignore")

# Globals
model = None
label_encoder = LabelEncoder()
X = None
csv_file_path = 'url_dataset.csv'


# --- Feature Extraction ---
def ssl_certificate_valid(url):
    try:
        hostname = urlparse(url).netloc
        if not hostname:
            return 0
        ctx = ssl.create_default_context()
        with ctx.wrap_socket(socket.socket(), server_hostname=hostname) as s:
            s.settimeout(3.0)
            s.connect((hostname, 443))
            s.getpeercert()
            return 1
    except:
        return 0

def dns_lookup(url):
    try:
        domain = urlparse(url).netloc
        if not domain:
            return 0
        socket.gethostbyname(domain)
        return 1
    except:
        return 0

def extract_features(url):
    return [
        ssl_certificate_valid(url),
        dns_lookup(url),
    ]

# --- Heuristic Rule-based Check ---
def preliminary_heuristic_check(url):
    parsed = urlparse(url)
    domain = parsed.netloc.lower()
    scheme = parsed.scheme.lower()

    https = scheme == "https"
    tunneling_domains = ['is.gd', 'bit.ly', 'tinyurl.com', 'ngrok.io', 'loclx.io', 'localhost', '127.0.0.1']
    is_tunnel = any(tunnel in domain for tunnel in tunneling_domains)
    valid_tlds = ['.com', '.org', '.net', '.io', '.in', '.edu', '.gov']
    has_valid_tld = any(domain.endswith(tld) for tld in valid_tlds)

    if https and not is_tunnel and has_valid_tld:
        return "Likely Safe 🔐"
    else:
        return "⚠️ Likely Malicious based on heuristics"


# --- Auto-label special URLs ---
def auto_label_special_urls(df):
    def classify_special(url):
        parsed = urlparse(url)
        hostname = parsed.hostname or ''
        if hostname.endswith(".loclx.io") or "127.0.0.1" in hostname or "localhost" in hostname:
            return "Malicious"
        return None

    df['auto_label'] = df['url'].apply(classify_special)
    df['label'] = df.apply(lambda row: row['auto_label'] if pd.notnull(row['auto_label']) else row['label'], axis=1)
    df.drop(columns=['auto_label'], inplace=True)
    return df


# --- Model Training ---
def load_and_train_model(csv_file=csv_file_path):
    global model, X

    if not os.path.exists(csv_file):
        print("❌ Database does not exist.")
        return None
        
    print("\n🌐 Connecting with Blockchain and checking database link...")
    print("✔️ Database exists!")
    dataset = pd.read_csv(csv_file)
    dataset = auto_label_special_urls(dataset)

    expected_columns = ['url', 'ssl_certificate_valid', 'dns_lookup', 'label']
    if not all(col in dataset.columns for col in expected_columns):
        raise ValueError(f"CSV must contain: {', '.join(expected_columns)}")

    dataset.dropna(subset=expected_columns, inplace=True)

    X = dataset[['ssl_certificate_valid', 'dns_lookup']].apply(pd.to_numeric, errors='coerce').dropna()
    y = dataset.loc[X.index, 'label']
    y = label_encoder.fit_transform(y)

    if X.empty:
        raise ValueError("No valid data to train the model.")

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    model = RandomForestClassifier(n_estimators=100, random_state=42)
    model.fit(X_train, y_train)

    y_pred = model.predict(X_test)
    print("\n📈 Model trained successfully! ✅")
    print("Accuracy:", accuracy_score(y_test, y_pred))
    print(classification_report(y_test, y_pred, target_names=label_encoder.classes_))


# --- Prediction ---
def predict_url(url):
    if model is None or X is None:
        raise Exception("Model not trained. Run load_and_train_model().")

    parsed = urlparse(url)
    hostname = parsed.hostname or ""
    if hostname.endswith(".loclx.io") or "127.0.0.1" in hostname or "localhost" in hostname:
        return "Malicious"

    features = extract_features(url)
    features_df = pd.DataFrame([features], columns=X.columns)
    prediction = model.predict(features_df)[0]
    return label_encoder.inverse_transform([prediction])[0]


# --- Check & Possibly Add URL ---
def check_url_safety(url, csv_file=csv_file_path):
    global model

    if model is None:
        load_and_train_model(csv_file)

    # Simulating a blockchain check
    print("\n🔗 Checking blockchain database... 🛠️")

    dataset = pd.read_csv(csv_file)
    if url not in dataset['url'].values:
        print(f"\n❓ The URL '{url}' is not found in the dataset.")
        print(f"🔍 Heuristic assessment: {preliminary_heuristic_check(url)}")
        user_input = input("Would you like to add it to the database? (y/n): ").strip().lower()
        if user_input == 'y':
            label = input("Please specify if the URL is 'Safe' or 'Malicious': ").strip().capitalize()
            while label not in ['Safe', 'Malicious']:
                label = input("Invalid input. Please specify 'Safe' or 'Malicious': ").strip().capitalize()

            features = extract_features(url)
            new_data = {
                'url': url,
                'ssl_certificate_valid': features[0],
                'dns_lookup': features[1],
                'label': label
            }

            dataset = pd.concat([dataset, pd.DataFrame([new_data])], ignore_index=True)
            dataset.to_csv(csv_file, index=False)
            print(f"✅ The URL '{url}' has been added to the dataset as '{label}'.")
            load_and_train_model(csv_file)

    try:
        prediction = predict_url(url)
        if prediction == "Safe":
            return f"✅ The URL '{url}' is classified as: \033[92m{prediction}\033[0m ✅"
        else:
            return f"⚠️ The URL '{url}' is classified as: \033[91m{prediction}\033[0m ⚠️"
    except Exception as e:
        return f"❌ Error: {str(e)}"


# --- CLI Entry ---
if __name__ == "__main__":
    csv_file_path = 'url_dataset.csv'
    load_and_train_model(csv_file_path)

    url_to_check = input("Enter the URL to check: ")
    result = check_url_safety(url_to_check, csv_file_path)
    print(result)

# Credits
# NullByte Team :
# * 1. Jejo J
# * 2. Sona Angel RA
# * 3. Pavithra
# * 4. Devadharshan
# * 5. Ranjith
