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
                sh "docker build -t ${DOCKER_IMAGE} ."
                echo 'Docker image built successfully.'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                    echo 'Logged into AWS ECR successfully.'
                }
            }
        }

        stage('Push to ECR') {
            steps {
                sh "docker push ${DOCKER_IMAGE}"
                echo 'Docker image pushed to ECR.'
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                    sh "aws eks update-kubeconfig --region ${AWS_REGION} --name notesapp-eks-cluster" // <-- UNCOMMENT AND UPDATE THIS LINE!
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl apply -f service.yaml'
                    echo 'Deployment applied to EKS.'
                }
            }
        }
    }
}
