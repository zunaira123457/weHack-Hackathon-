from flask import Flask, jsonify, request
from flask_cors import CORS
from pymongo import MongoClient
from datetime import datetime
import os
from dotenv import load_dotenv

load_dotenv()
atlas_connection_string = os.getenv('MONGO_ATLAS_URI')
if not atlas_connection_string:
    raise ValueError("Atlas connection string not found in .env file")
client = MongoClient(atlas_connection_string) # Use your Atlas link if on cloud

app = Flask(__name__)
CORS(app)  # Allow cross-origin requests (important for Flutter)

# Connect to MongoDB
db = client["ehr_database"]
patients = db["patients"]

@app.route("/patients", methods=["GET"])
def get_patients():
    all_patients = list(patients.find({}, {"_id": 0}))  # hide _id
    return jsonify(all_patients)

@app.route("/patients", methods=["POST"])
def add_patient():
    data = request.json
    data["created_at"] = datetime.utcnow().isoformat()
    patients.insert_one(data)
    return jsonify({"message": "Patient added!"})

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000, use_reloader=False)