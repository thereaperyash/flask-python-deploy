pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                // This checks out your code from the GitHub repository linked below
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building your Flask application Docker image..."
                    // This looks for a file named 'Dockerfile' in your root directory
                    // Replace 'my-flask-app:local' with whatever you want to name your image for now
                    docker.build("my-flask-app:local")
                }
            }
        }
    }
}


