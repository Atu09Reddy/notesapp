pipeline {
    // Change 'agent any' to specify a Docker image
    agent {
        docker {
            image 'my-jenkins-agent:latest' // Replace with your agent image name/tag
            args '-v /var/run/docker.sock:/var/run/docker.sock' // Mount Docker socket for Docker-in-Docker or host Docker access
        }
    }

    environment {
        AWS_ACCOUNT_ID      = '344000030130'
        AWS_REGION          = 'us-east-1'
        ECR_REPOSITORY      = 'myapp/notesapp'
        IMAGE_TAG           = 'latest'
        ECR_REGISTRY        = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        DOCKER_IMAGE        = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
        AWS_CREDENTIALS_ID  = 'aws-eks-cred'
        KUBECONFIG_CLUSTER_NAME = 'notesapp-eks-cluster'
        KUBECTL_CONTEXT_NAME = "arn:aws:eks:${AWS_REGION}:${AWS_ACCOUNT_ID}:cluster/${KUBECONFIG_CLUSTER_NAME}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Atu09Reddy/myapp/notesapp.git'
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
                    sh "aws eks update-kubeconfig --region ${AWS_REGION} --name ${KUBECONFIG_CLUSTER_NAME}"
                    sh "kubectl config use-context ${KUBECTL_CONTEXT_NAME}"
                    sh 'kubectl apply -f deployment.yaml -n my-app'
                    sh 'kubectl apply -f service.yaml -n my-app'
                    echo 'Deployment applied to EKS.'
                }
            }
        }
    }
}