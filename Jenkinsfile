pipeline {
    agent any // The initial agent that will run the 'Checkout' and 'Build Jenkins Agent Image' stages

    environment {
        AWS_ACCOUNT_ID      = '344000030130'
        AWS_REGION          = 'us-east-1'
        ECR_REPOSITORY      = 'myapp/notesapp' // <-- Keep this if your ECR repo is truly 'myapp/notesapp'
        IMAGE_TAG           = 'latest'
        ECR_REGISTRY        = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        DOCKER_IMAGE        = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
        AWS_CREDENTIALS_ID  = 'aws-eks-cred'
        KUBECONFIG_CLUSTER_NAME = 'notesapp-eks-cluster'
        KUBECTL_CONTEXT_NAME = "arn:aws:eks:${AWS_REGION}:${AWS_ACCOUNT_ID}:cluster/${KUBECONFIG_CLUSTER_NAME}"

        JENKINS_AGENT_IMAGE_NAME = "my-jenkins-agent"
        JENKINS_AGENT_FULL_IMAGE = "${ECR_REGISTRY}/${JENKINS_AGENT_IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {
        stage('Checkout') {
            steps {
                // This line now matches your confirmed GitHub repository URL
                git branch: 'main', url: 'https://github.com/Atu09Reddy/notesapp.git'
                echo 'Checked out the repository successfully...'
            }
        }

        stage('Build and Push Jenkins Agent Image') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                        echo "Logged into AWS ECR for building and pushing agent image."
                    }
                    sh "docker build -t ${JENKINS_AGENT_FULL_IMAGE} -f jenkins-agent.Dockerfile ."
                    echo "Jenkins agent Docker image built: ${JENKINS_AGENT_FULL_IMAGE}"
                    sh "docker push ${JENKINS_AGENT_FULL_IMAGE}"
                    echo "Jenkins agent Docker image pushed to ECR."
                }
            }
        }

        stage('Run Pipeline in Custom Agent') {
            agent {
                docker {
                    image "${JENKINS_AGENT_FULL_IMAGE}"
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            stages {
                stage('Build Application Docker Image') {
                    steps {
                        sh "docker build -t ${DOCKER_IMAGE} ."
                        echo 'Application Docker image built successfully.'
                    }
                }

                stage('Login to AWS ECR for App Image') {
                    steps {
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                            sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                            echo 'Logged into AWS ECR successfully for app image.'
                        }
                    }
                }

                stage('Push Application Image to ECR') {
                    steps {
                        sh "docker push ${DOCKER_IMAGE}"
                        echo 'Application Docker image pushed to ECR.'
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
    }
}