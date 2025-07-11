pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = '344000030130'
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY = 'notesapp'
        IMAGE_TAG = 'latest'
        ECR_REGISTRY = "344000030130.dkr.ecr.us-east-1.amazonaws.com"
        DOCKER_IMAGE = "344000030130.dkr.ecr.us-east-1.amazonaws.com/notesapp:latest" // This variable is not used in the commands, but kept for consistency
        AWS_CREDENTIALS_ID = 'aws-eks-cred'
    }

    stages {
        stage('checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Atu09Reddy/notesapp.git'
                sh 'Checked out the repository successfully...'
            }
        }

        stage('Build'){
            steps {
                // Build with the full ECR tag directly
                sh 'docker build -t 344000030130.dkr.ecr.us-east-1.amazonaws.com/notesapp:latest .'
                sh 'docker build done .....'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 344000030130.dkr.ecr.us-east-1.amazonaws.com'
                    sh 'Logged into AWS ECR successfully...'
                }
            }
        }

        stage('Push to ECR') {
            steps {
                // No need for 'docker tag' as the build already applied the correct tag
                sh 'docker push 344000030130.dkr.ecr.us-east-1.amazonaws.com/notesapp:latest'
                sh 'Pushed to ECR successfully...'
            }
        }

        stage('Deploy to EKS') { // Renamed from ECS as you're using kubectl
            steps {
                // Apply the deployment and service manifests.
                // kubectl apply -f will create them if they don't exist,
                // and update them if they do. This is the standard way.
                sh 'kubectl apply -f deployment.yaml' // Assuming the files are in the root of the workspace or specify k8s/deployment.yaml
                sh 'kubectl apply -f service.yaml'   // Assuming the files are in the root of the workspace or specify k8s/service.yaml
                sh 'Deployed to EKS successfully...'
            }
        }
    }
}