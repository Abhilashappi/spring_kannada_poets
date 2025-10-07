pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_USER = "${DOCKERHUB_CREDENTIALS_USR}"
        DOCKER_PASS = "${DOCKERHUB_CREDENTIALS_PSW}"
        IMAGE_NAME = "${DOCKER_USER}/spring_kannada_poets"
        TAG = "latest"
        REMOTE = "ubuntu@13.200.254.201"  // ✅ Replace with your actual EC2 IP
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Abhilashappi/spring_kannada_poets.git'
            }
        }

        stage('Build WAR') {
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

        stage('Deploy to EC2 Server') {
            steps {
                sshagent(['ubuntu']) {  // ✅ This ID must match your Jenkins SSH credential ID
                    sh """
                        ssh -o StrictHostKeyChecking=no ${REMOTE} << 'EOF'
                          echo "🔹 Pulling latest Docker image..."
                         sudo docker pull ${IMAGE_NAME}:${TAG}

                          echo "🔹 Stopping old container if exists..."
                         sudo docker stop spring_kannada_poets || true
                         sudo docker rm spring_kannada_poets || true

                          echo "🔹 Running new container..."
                         sudo docker run -d -p 8080:8080 --name spring_kannada_poets ${IMAGE_NAME}:${TAG}

                          echo "✅ Deployment successful on EC2 instance!"
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
}
