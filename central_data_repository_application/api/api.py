from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
import os
import io
import psycopg2
from psycopg2.extras import RealDictCursor
import pandas as pd
from datetime import datetime
from dateutil.parser import parse


app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads/'
column_names = ["labelId","serial","userId","inear(1=in)","timestamp","cmic_leq_a","cmic_peak_c","CDiag1","CDiag2","CDiag3","CDiag4","CDiag5","rmic_leq_a","rmic_peak_c","RDiag1","RDiag2","RDiag3","RDiag4","RDiag5","lmic_leq_a","lmic_peak_c","LDiag1","LDiag2","LDiag3","LDiag4","LDiag5","battv","flags","flags_ext","event_id","accel_mean","accel_peak","doseR","doseL","pmic_thmAvg"]
database_url = os.getenv('DATABASE_URL', 'default_connection_string')

def get_db_connection():
    conn = psycopg2.connect(database_url)
    return conn

@app.route('/')
def index():
    return "Welcome to the Flask API!"

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
            return jsonify({"error": "No file provided"}), 400
    file = request.files['file']
    if file.filename == '':
            return jsonify({"error": "No file provided"}), 400
    file = request.files['file']
    filename = secure_filename(file.filename)
    if not filename.endswith('.csv'):
            return jsonify({"error": "Only CSV files are supported"}), 400
    file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    file.save(file_path)
    with open(file_path, 'r') as file:
            lines = file.readlines()
            lines = [line.rstrip(',\n') for line in lines]
            actual_headers = lines[0].split(',')
            if not all(column in actual_headers for column in column_names):
                    return jsonify({"error": "File has incorrect format"}), 400
            modified_csv = '\n'.join(lines)
    # Extract metadata
    try:
            df = pd.read_csv(io.StringIO(modified_csv), skiprows=1,  header=None, names=column_names)
            labels = df['inear(1=in)'].unique()
            if(len(labels) != 1):
                    return jsonify({"error": "File contains data from more than one label"}), 400
            else:
                    label = str(labels[0])    
            label_ids = df['labelId'].unique()
            if(len(label_ids) != 1):
                    return jsonify({"error": "File contains data from more than one labelId"}), 400
            else:
                    label_id = str(label_ids[0])    
            earplug_ids = df['serial'].unique()
            if(len(earplug_ids) != 1):
                    return jsonify({"error": "File contains data from more than one earplug"}), 400
            else:
                    earplug_id = str(earplug_ids[0])    
            user_ids = df['userId'].unique()
            if(len(user_ids) != 1):
                    return jsonify({"error": "File contains data from more than one user"}), 400
            else:
                    user_id = str(user_ids[0])
            timestamp_start = datetime.fromtimestamp(df['timestamp'].min())
            timestamp_end = datetime.fromtimestamp(df['timestamp'].max())
            file_length = df.shape[0]
            upload_date = datetime.now()    
            conn = get_db_connection()
            cur = conn.cursor(cursor_factory=RealDictCursor)
            cur.execute("INSERT INTO csv_metadata (file_name, label, label_id, earplug_id, user_id, timestamp_start, timestamp_end, file_path, file_length, upload_date) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING file_name, label, label_id, earplug_id, user_id, timestamp_start, timestamp_end", (filename, label, label_id, earplug_id, user_id, timestamp_start, timestamp_end, file_path, file_length, upload_date))
            inserted_row = cur.fetchone()
            conn.commit()
            cur.close()
            conn.close()
            return jsonify({"message": "File uploaded successfully", "data": inserted_row}), 201
    except Exception as e:
            return jsonify({"error": "Unknown error"}), 500

@app.route('/data', methods=['GET'])
def get_data():
    label = request.args.get('label')
    label_id = request.args.get('labelId')
    file_name = request.args.get('file_name')
    earplug_id = request.args.get('earplug_id')
    user_id = request.args.get('user_id')
    timestamp_start = request.args.get('timestamp_start')
    timestamp_end = request.args.get('timestamp_end')
    
    try:
        if timestamp_start:
            timestamp_start = parse(timestamp_start)
        if timestamp_end:
            timestamp_end = parse(timestamp_end)
    except ValueError:
        return jsonify({"error": "Invalid datetime format for timestamps"}), 400
    
    query = "SELECT * FROM csv_metadata WHERE TRUE"
    params = []
    
    if label:
        query += " AND label = %s"
        params.append(label)
    if label_id:
        query += " AND label_id = %s"
        params.append(label_id)
    if file_name:
        query += " AND file_name = %s"
        params.append(file_name)
    if earplug_id:
        query += " AND earplug_id = %s"
        params.append(earplug_id)
    if user_id:
        query += " AND user_id = %s"
        params.append(user_id)
    if timestamp_start:
        query += " AND timestamp_start >= %s"
        params.append(timestamp_start)
    if timestamp_end:
        query += " AND timestamp_end <= %s"
        params.append(timestamp_end)
    
    try:
        conn = get_db_connection()
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute(query, params)
        rows = cur.fetchall()
        return jsonify(rows), 200
    except Exception as e:
        return jsonify({"error": "Failed to retrieve data", "details": str(e)}), 500
    finally:
        cur.close()
        conn.close()


@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.config['UPLOAD_FOLDER'] = os.environ.get('UPLOAD_FOLDER', '/tmp')
    app.run(host='0.0.0.0', port=5000, debug=True)
