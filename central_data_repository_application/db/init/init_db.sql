CREATE TABLE IF NOT EXISTS csv_metadata (
    id SERIAL PRIMARY KEY,
    file_name VARCHAR(50) NOT NULL UNIQUE,
    label BOOLEAN NOT NULL,
    label_id INT NOT NULL UNIQUE,
    earplug_id VARCHAR(8) NOT NULL,
    user_id INT,
    timestamp_start TIMESTAMP NOT NULL,
    timestamp_end TIMESTAMP NOT NULL,
    file_path TEXT NOT NULL UNIQUE,
    file_length INT NOT NULL,
    upload_date TIMESTAMP NOT NULL
);
