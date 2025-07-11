pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = credentials('344000030130')
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY = 'notesapp'
        IMAGE_TAG = 'latest'
        DOCKER_IMAGE = "344000030130.dkr.ecr.us-east-1.amazonaws.com/notesapp:latest"
    }

    stages {
        stage('checkout') {
            steps {
                git 'https://github.com/Atu09Reddy/notesapp.git'
            }
        }

        stage('Build'){
            steps {
                sh 'docker build -t notesapp:latest .'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 344000030130.dkr.ecr.us-east-1.amazonaws.com/notesapp:latest'
                }
            }
        }

        stage('Push to ECR') {
            steps {
                sh 'docker tag notesapp:latest 344000030130.dkr.ecr.us-east-1.amazonaws.com/notesapp:latest'
                sh 'docker push 344000030130.dkr.ecr.us-east-1.amazonaws.com/notesapp:latest'
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh 'kubectl set image deployment/notesapp notesapp=344000030130.dkr.ecr.us-east-1.amazonaws.com/notesapp:latest'
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
            }
        }
    }
}