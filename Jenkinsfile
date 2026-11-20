pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Setting up Python environment'
                bat 'python -m venv venv'
                bat 'venv\\Scripts\\python.exe -m pip install -r requirements.txt'
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit tests'
                bat 'venv\\Scripts\\python.exe -m pytest -v'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying Flask application'
                bat 'if not exist deploy mkdir deploy'
                bat 'copy /Y app.py deploy\\app.py'
            }
        }

        stage('Run Application') {
            steps {
                echo 'Starting Flask application'
                bat 'powershell -NoProfile -ExecutionPolicy Bypass -File run_app.ps1'
            }
        }

        stage('Test Application') {
            steps {
                echo 'Verifying deployed application'
                bat 'powershell -NoProfile -ExecutionPolicy Bypass -File verify_app.ps1'
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }
        failure {
            echo 'CI/CD Pipeline failed. Check console logs.'
        }
        always {
            echo 'Pipeline execution finished.'
        }
    }
}
