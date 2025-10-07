pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_USER = "${DOCKERHUB_CREDENTIALS_USR}"
        DOCKER_PASS = "${DOCKERHUB_CREDENTIALS_PSW}"
        IMAGE_REPO = "${DOCKER_USER}/spring_kannada_poets"
        TAG = "latest"
        REMOTE = "ubuntu@13.200.254.201"  // Your EC2 connection string
        CONTAINER_NAME = "spring_kannada_poets"
        HOST_PORT = "8080"
        CONTAINER_PORT = "8084"
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
                sh "docker build -t ${IMAGE_REPO}:${TAG} ."
            }
        }

        stage('Push to DockerHub') {
            steps {
                // Warning: Passing secrets via Groovy string interpolation is insecure, but typical for non-credential login
                sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                sh "docker push ${IMAGE_REPO}:${TAG}"
            }
        }

        stage('Deploy to EC2 Server') {
            steps {
                // The SSH key must be the correct format (which you fixed!)
                sshagent(['ubuntu']) {
                    // Pass a robust script string to the remote SSH session
                    sh """
                        REMOTE_COMMANDS="
                          # 1. STOP and REMOVE old container. '|| true' ensures the step doesn't fail if the container isn't running.
                          echo '🔹 Stopping and removing old container...'
                          docker stop ${CONTAINER_NAME} || true
                          docker rm ${CONTAINER_NAME} || true

                          # 2. Pull the latest image
                          echo '🔹 Pulling latest Docker image: ${IMAGE_REPO}:${TAG}...'
                          docker pull ${IMAGE_REPO}:${TAG}

                          # 3. Run the new container, mapping ${HOST_PORT} to ${CONTAINER_PORT}
                          echo '🔹 Running new container...'
                          docker run -d \\
                            --name ${CONTAINER_NAME} \\
                            -p ${HOST_PORT}:${CONTAINER_PORT} \\
                            ${IMAGE_REPO}:${TAG}

                          echo '✅ Deployment completed successfully.'
                        "
                        # Execute the full command string on the remote server
                        ssh -o StrictHostKeyChecking=no ${REMOTE} "\${REMOTE_COMMANDS}"
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline Success: Build, Push, and Deployment completed."
        }
        failure {
            echo "❌ Pipeline Failure: Check logs for details."
        }
    }
}
