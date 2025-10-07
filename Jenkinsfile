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
                        # SSH command structure
ssh -o StrictHostKeyChecking=no ubuntu@13.200.254.201 << EOF
  # 1. Stop and remove old container robustly
  echo "🔹 Stopping and removing old container..."
  docker stop spring_kannada_poets || true
  docker rm spring_kannada_poets || true

  # 2. Pull the latest image
  echo "🔹 Pulling latest Docker image..."
  docker pull abhi539/host:latest

  # 3. Run the new container
  echo "🔹 Running new container..."
  # -p 8080:8084 maps Host Port 8080 to Container Port 8084
  docker run -d --name spring_kannada_poets -p 8080:8084 abhi539/host:latest


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
