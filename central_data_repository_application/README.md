# Central Data Repository Application

This directory contains all the necessary files for building and running the central data repository application used in my master thesis. It includes a Flask API server that interacts with a PostgreSQL database, both of which are containerized using Docker.

## Directory Structure

- **`Dockerfile`**:
  - Dockerfile for building the Flask API server Docker image.

- **`api`**:
  - Contains the Flask application:
    - **`api.py`**: The main Flask application file that defines API endpoints and logic.

- **`db`**:
  - Contains SQL scripts for database initialization:
    - **`init`**:
      - **`init_db.sql`**: SQL script to create and initialize the database schema.

- **`docker-compose.yml`**:
  - Docker Compose file to orchestrate the multi-container Docker application, including the API server and the database.

- **`requirements.txt`**:
  - Specifies Python packages that are required for the Flask application.

- **`.gitlab-ci.yml`**:
  - Defines the GitLab CI/CD pipeline for automating builds, tests, and deployment of the Flask application.

## Usage

To run the central data repository application:

1. **Build and Run the Containers**:
   - Ensure Docker and Docker Compose are installed on your system.
   - Navigate to this directory and run:
     ```bash
     docker-compose up --build
     ```
   - This command builds the Docker image for the API server based on the Dockerfile and starts all services defined in `docker-compose.yml`.

2. **Accessing the Application**:
   - Once the containers are running, the Flask API will be accessible at `http://localhost:5000` or another port configured in the `docker-compose.yml`.

3. **Database Initialization**:
   - The database is automatically initialized with the schema defined in `init_db.sql` when the PostgreSQL container is first created.

## CI/CD Pipeline

The `.gitlab-ci.yml` file configures the simple GitLab CI/CD pipeline to automatically build, and deploy the Flask application whenever changes are committed to the repository. This automation ensures a consistent and error-free deployment process, which is crucial for maintaining the reliability of the application.

## Important Notes

- **Documentation Purpose**: The files and configurations in this directory are primarily provided for documentation and archival purposes. They illustrate the setup and management processes used during the thesis project and are not intended for direct reuse without modification.
- **Configuration**: Before running the application, ensure that any necessary environment variables or configurations are set in the `docker-compose.yml` or within the application's environment.
- **Security**: If deploying to a production environment, ensure that the Docker configurations and application settings are secure, especially regarding database credentials and network settings.
