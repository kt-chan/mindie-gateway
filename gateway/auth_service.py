import os
import sys
import logging
from flask import Flask, request, jsonify

app = Flask(__name__)

# Configure logging to write to stdout
logging.basicConfig(
    stream=sys.stdout,
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)


# Explicitly configure logging to write to stdout
def load_api_keys():
    api_keys = set()

    # Load from environment variable
    env_keys = os.environ.get("OPENAI_API_KEYS")
    if env_keys:
        api_keys.update(env_keys.split(","))
        logger.info("Loaded API keys from environment variable")

    # Load from file
    key_file = "/etc/nginx/api_keys.txt"
    if os.path.exists(key_file):
        try:
            with open(key_file, "r") as f:
                file_keys = [line.strip() for line in f if line.strip()]
                api_keys.update(file_keys)
                logger.info("Loaded API keys from file")
        except Exception as e:
            logger.error(f"Error reading key file: {e}")

    return api_keys


VALID_API_KEYS = load_api_keys()


@app.route("/validate", methods=["GET", "POST"])
def validate_key():
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        return jsonify({"error": "Invalid Authorization header"}), 401

    api_key = auth_header[7:]
    if api_key in VALID_API_KEYS:
        logger.info(f"Authticatioin Valid for {auth_header[:10]}")
        return jsonify({"status": "valid"}), 200
    else:
        logger.error(f"Authticatioin Failed for {auth_header[:10]}")
        return jsonify({"error": "Invalid API key"}), 401


@app.route("/health", methods=["GET"])
def health_check():
    return jsonify({"status": "healthy"}), 200
