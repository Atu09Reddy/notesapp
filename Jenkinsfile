pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = '344000030130'
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY = 'notesapp'
        IMAGE_TAG = 'latest'
        ECR_REGISTRY = "344000030130.dkr.ecr.us-east-1.amazonaws.com"
        DOCKER_IMAGE = "344000030130.dkr.ecr.us-east-1.amazonaws.com/notesapp:latest"
        AWS_CREDENTIALS_ID = 'aws-eks-cred'
    }

    stages {
        stage('Checkout Source Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Atu09Reddy/notesapp.git'
                echo 'Source code checked out successfully.'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the Docker image with the direct value of DOCKER_IMAGE
                sh "docker build -t 344000030130.dkr.ecr.us-east-1.amazonaws.com/notesapp:latest ."
                echo 'Docker image built successfully.'
            }
        }

        stage('Login and Push to AWS ECR') {
            steps {
                script {
                    // Use the 'withAWS' step with direct values for credentials and region
                    withAWS(credentials: 'aws-eks-cred', region: 'us-east-1') {
                        // Push the Docker image with its direct name
                        sh "docker push 344000030130.dkr.ecr.us-east-1.amazonaws.com/notesapp:latest"
                        echo 'Docker image pushed to ECR successfully.'
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                // Use the 'withAWS' block with direct values for credentials and region
                withAWS(credentials: 'aws-eks-cred', region: 'us-east-1') {
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl apply -f service.yaml'
                    echo 'Deployed to EKS successfully.'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
        success {
            echo 'Build and deployment succeeded.'
        }
        failure {
            echo 'Build or deployment failed.'
        }
    }
}