pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_USER = "${DOCKERHUB_CREDENTIALS_USR}"
        DOCKER_PASS = "${DOCKERHUB_CREDENTIALS_PSW}"
        IMAGE_NAME = "${DOCKER_USER}/spring_kannada_poets"
        TAG = "latest"
        REMOTE = "ubuntu@<EC2_PUBLIC_IP>"   // change as needed
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Abhilashappi/spring_kannada_poets.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${TAG} ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                    sh "docker push ${IMAGE_NAME}:${TAG}"
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${REMOTE} << 'EOF'
                      docker pull ${IMAGE_NAME}:${TAG}
                      docker stop spring_kannada_poets || true
                      docker rm spring_kannada_poets || true
                      docker run -d --name spring_kannada_poets -p 8080:8080 ${IMAGE_NAME}:${TAG}
                    EOF
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment succeeded."
        }
        failure {
            echo "❌ Deployment failed."
        }
    }
} ( how to run this
