pipeline {
    agent any

    tools {
        maven 'maven' // Ensure Maven is configured under Jenkins tools
    }

    environment {
        DOCKERHUB_CREDENTIALS_ID = 'dockerhub-credentials'   // Your Jenkins credential ID
        DOCKERHUB_USERNAME       = 'abhilashappi'            // Your DockerHub username
        IMAGE_NAME               = "${env.DOCKERHUB_USERNAME}/spring-kannada-poets"
        CONTAINER_NAME           = "spring-kannada-poets-container"
    }

    stages {

        stage('Checkout Source') {
            steps {
                echo '📦 Checking out source code...'
                git branch: 'master', url: 'https://github.com/Abhilashappi/spring_kannada_poets.git'
            }
        }

        stage('Build WAR with Maven') {
            steps {
                echo '🔨 Building project with Maven...'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image: ${IMAGE_NAME}:${BUILD_NUMBER}"
                sh "sudo docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('Login to Docker Hub') {
            steps {
                echo '🔐 Logging in to Docker Hub...'
                withCredentials([usernamePassword(
                    credentialsId: env.DOCKERHUB_CREDENTIALS_ID, 
                    usernameVariable: 'DOCKER_USER', 
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | sudo docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo "📤 Pushing image: ${IMAGE_NAME}:${BUILD_NUMBER}"
                    sh "sudo docker push ${IMAGE_NAME}:${BUILD_NUMBER}"

                    echo "🏷️ Tagging as latest..."
                    sh "sudo docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${IMAGE_NAME}:latest"

                    echo "📤 Pushing latest tag..."
                    sh "sudo docker push ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Clean Up Local Images') {
            steps {
                echo '🧹 Cleaning up local Docker images...'
                sh "sudo docker rmi ${IMAGE_NAME}:${BUILD_NUMBER} || true"
                sh "sudo docker rmi ${IMAGE_NAME}:latest || true"
            }
        }

        stage('Deploy Container') {
            steps {
                echo "🚀 Deploying container: ${CONTAINER_NAME} on port 8084..."
                sh "sudo docker stop ${CONTAINER_NAME} || true"
                sh "sudo docker rm ${CONTAINER_NAME} || true"
                sh "sudo docker run -d -p 8084:8080 --name ${CONTAINER_NAME} ${IMAGE_NAME}:latest"
            }
        }
    }

    post {
        always {
            echo '🔁 Pipeline completed (always runs).'
        }
        success {
            echo '✅ Build and deployment succeeded!'
        }
        failure {
            echo '❌ Build or deployment failed!'
        }
    }
}
