pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID      = '344000030130'
        AWS_REGION          = 'us-east-1'
        ECR_REPOSITORY      = 'myapp/notesapp' // <--- THIS IS THE CRUCIAL CHANGE
        IMAGE_TAG           = 'latest'
        ECR_REGISTRY        = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        DOCKER_IMAGE        = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}" // This will now correctly become 3440.../myapp/notesapp:latest
        AWS_CREDENTIALS_ID  = 'aws-eks-cred'
        KUBECONFIG_CLUSTER_NAME = 'notesapp-eks-cluster'
        KUBECTL_CONTEXT_NAME = "arn:aws:eks:${AWS_REGION}:${AWS_ACCOUNT_ID}:cluster/${KUBECONFIG_CLUSTER_NAME}"
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
                // Assuming Dockerfile is in the root of the checked-out repository
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
                    // Update kubeconfig for the Jenkins agent to interact with EKS
                    sh "aws eks update-kubeconfig --region ${AWS_REGION} --name ${KUBECONFIG_CLUSTER_NAME}"
                    // Use the correct kubectl context after updating kubeconfig
                    // This ensures kubectl commands are directed to the correct cluster
                    sh "kubectl config use-context ${KUBECTL_CONTEXT_NAME}"
                    sh 'kubectl apply -f deployment.yaml -n my-app' // Specify namespace for clarity and safety
                    sh 'kubectl apply -f service.yaml -n my-app'   // Specify namespace for clarity and safety
                    echo 'Deployment applied to EKS.'
                }
            }
        }
    }
}
