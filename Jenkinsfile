pipeline {
    agent any
    
    environment {
        AWS_REGISTRY_ID = '531572985235' 
        AWS_REGION      = 'ap-southeast-2'
        ECR_REPO_NAME   = 'cicdflask'
        IMAGE_TAG       = "${BUILD_NUMBER}" // Uses the Jenkins build number (e.g., 2, 3, 4) as the unique version tag
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    // Tags the local build with your specific ECR repository path
                    myImage = docker.build("${AWS_REGISTRY_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push to ECR') {
            steps {
                // Using Option B: Injects the AWS Credentials you saved inside Jenkins
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'aws-credentials' // Verify this matches the exact ID of your credentials in Jenkins!
                ]]) {
                    script {
                        echo "Logging into AWS ECR..."
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_REGISTRY_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                        
                        echo "Pushing image to ECR..."
                        sh "docker push ${AWS_REGISTRY_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Terraform Provision') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'aws-credentials'
                ]]) {
                    // This switches Jenkins context into your /terraform folder containing main.tf
                    dir('terraform') { 
                        echo "Initializing and Applying Terraform..."
                        sh 'terraform init'
                        // Passes the exact IMAGE_TAG from Jenkins straight into your Terraform variable
                        sh "terraform apply -var='image_tag=${IMAGE_TAG}' -auto-approve"
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo "Cleaning up local build images to save EC2 space..."
            sh "docker rmi ${AWS_REGISTRY_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG} || true"
        }
    }
}


