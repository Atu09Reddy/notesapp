pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID     = '344000030130'
        AWS_REGION         = 'us-east-1'
        ECR_REPOSITORY     = 'notesapp'
        IMAGE_TAG          = 'latest'
        ECR_REGISTRY       = "344000030130.dkr.ecr.us-east-1.amazonaws.com"
        DOCKER_IMAGE       = "344000030130.dkr.ecr.us-east-1.amazonaws.com/notesapp:latest"
        AWS_CREDENTIALS_ID = 'aws-eks-cred'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Atu09Reddy/notesapp.git'
                echo 'Checked out the repository successfully...'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t 344000030130.dkr.ecr.us-east-1.amazonaws.com/notesapp:latest .'
                echo 'Docker image built successfully.'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-eks-cred']]) {
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 344000030130.dkr.ecr.us-east-1.amazonaws.com'
                    echo 'Logged into AWS ECR successfully.'
                }
            }
        }

        stage('Push to ECR') {
            steps {
                sh 'docker push 344000030130.dkr.ecr.us-east-1.amazonaws.com/notesapp:latest'
                echo 'Docker image pushed to ECR.'
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-eks-cred']]) {
                    // Optional: update kubeconfig if needed
                    // sh 'aws eks update-kubeconfig --region us-east-1 --name <your-cluster-name>'
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl apply -f service.yaml'
                    echo 'Deployment applied to EKS.'
                }
            }
        }
    }
}
