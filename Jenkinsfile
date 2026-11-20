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
                bat 'powershell -NoProfile -Command "$p = Start-Process -FilePath (Resolve-Path venv\\Scripts\\python.exe) -ArgumentList ''deploy\\app.py'' -PassThru; Set-Content app.pid $p.Id"'
            }
        }

        stage('Test Application') {
            steps {
                echo 'Verifying deployed application'
                bat 'powershell -NoProfile -Command "$ok = $false; for ($i=0; $i -lt 15; $i++) { try { $r = Invoke-RestMethod http://localhost:5000/ -TimeoutSec 2; if ($r.status -eq ''success'') { $ok = $true; break } } catch { Start-Sleep -Seconds 2 } }; if (-not $ok) { throw ''Application verification failed'' }"'
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
