import json
from flask import Flask, request
import requests

app = Flask(__name__)
KEYS_FILE = "keys.json"
GITHUB_RAW_URL = "https://raw.githubusercontent.com/username/MyBotRepo/main/"

# Redeem key and lock IP
@app.route("/redeem", methods=["POST"])
def redeem():
    data = request.json
    key = data.get("key")
    user = data.get("user")
    user_ip = request.remote_addr
    with open(KEYS_FILE) as f:
        keys = json.load(f)
    if key in keys and not keys[key]["redeemed"]:
        keys[key]["redeemed"] = True
        keys[key]["user"] = user
        keys[key]["allowed_ip"] = user_ip
        with open(KEYS_FILE, "w") as f:
            json.dump(keys, f)
        return {"status": "success", "ip": user_ip}
    return {"status": "invalid_or_used"}

# Serve Lua script if key is valid and IP matches
@app.route("/getscript", methods=["GET"])
def get_script():
    key = request.args.get("key")
    script_name = request.args.get("script", "example.lua")
    user_ip = request.remote_addr

    with open(KEYS_FILE) as f:
        keys = json.load(f)
    if key not in keys or not keys[key]["redeemed"]:
        return "invalid"
    if keys[key]["allowed_ip"] != user_ip:
        return "ip_mismatch"

    # Fetch script from GitHub
    github_url = f"{GITHUB_RAW_URL}{script_name}"
    r = requests.get(github_url)
    if r.status_code != 200:
        return "script_not_found"
    return r.text

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
