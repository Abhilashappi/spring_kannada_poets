pipeline {
    agent any

    tools {
        maven 'maven'
    }

    environment {
        IMAGE_NAME = 'spring-kannada-poets'
        DOCKER_REPO = 'abhi539/spring-kannada-poets'
        CONTAINER_NAME = 'spring_kannada_poets_container'
        PORT = '8084'
    }

    stages {
        stage('Build') {
            steps {
                echo "Building the project..."
                sh 'mvn clean package -DskipTests'
            }
            post {
                success {
                    echo 'Build stage completed successfully.'
                }
                failure {
                    echo 'Build stage failed.'
                }
            }
        }

        stage('Docker Build the Image') {
            steps {
                echo "Building the Docker image..."
                sh 'sudo docker build -t $IMAGE_NAME .'
            }
            post {
                success {
                    echo 'Docker image built successfully.'
                }
                failure {
                    echo 'Docker image build failed.'
                }
            }
        }

        stage('Docker Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-cred-id',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                        echo "$PASS" | sudo docker login -u "$USER" --password-stdin
                    '''
                }
            }
        }

        stage('Docker Tag the Image') {
            steps {
                echo "Tagging the Docker image..."
                sh 'sudo docker tag $IMAGE_NAME $DOCKER_REPO:latest'
            }
            post {
                success {
                    echo 'Docker image tagged successfully.'
                }
                failure {
                    echo 'Failed to tag Docker image.'
                }
            }
        }

        stage('Docker Push the Image') {
            steps {
                echo "Pushing the Docker image to DockerHub..."
                sh 'sudo docker push $DOCKER_REPO:latest'
            }
            post {
                success {
                    echo 'Docker image pushed to DockerHub successfully.'
                }
                failure {
                    echo 'Failed to push Docker image to DockerHub.'
                }
            }
        }

        stage('Cleanup Local Docker Images') {
            steps {
                echo "Cleaning up local Docker images..."
                sh '''
                    sudo docker rmi $DOCKER_REPO:latest || true
                    sudo docker rmi $IMAGE_NAME || true
                '''
            }
            post {
                success {
                    echo 'Local Docker images cleaned up successfully.'
                }
                failure {
                    echo 'Failed to clean up local Docker images.'
                }
            }
        }

        stage('Docker Logout from DockerHub') {
            steps {
                echo "Logging out from DockerHub..."
                sh 'sudo docker logout'
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    echo "Checking if the Docker container is already running..."
                    def containerExists = sh(
                        script: "sudo docker ps -a --format '{{.Names}}' | grep -w $CONTAINER_NAME || true",
                        returnStdout: true
                    ).trim()

                    if (containerExists) {
                        echo "Container '$CONTAINER_NAME' already exists."
                        def userChoice = input(
                            id: 'ContainerRestart',
                            message: 'Container already running. Do you want to stop and redeploy?',
                            parameters: [choice(choices: ['Yes', 'No'], description: 'Choose action', name: 'Confirm')]
                        )

                        if (userChoice == 'Yes') {
                            echo "Stopping and removing old container..."
                            sh '''
                                sudo docker stop $CONTAINER_NAME || true
                                sudo docker rm $CONTAINER_NAME || true
                                echo "Starting new container..."
                                sudo docker run -d -p 8084:8080 --name $CONTAINER_NAME $DOCKER_REPO:latest
                            '''
                        } else {
                            echo "Skipping container restart as per user choice."
                        }
                    } else {
                        echo "No existing container found — starting new one..."
                        sh 'sudo docker run -d -p 8084:8080 --name $CONTAINER_NAME $DOCKER_REPO:latest'
                    }
                }
            }
        }

        stage('Done') {
            steps {
                echo "Pipeline execution completed."
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished execution.'
        }
        success {
            echo 'Pipeline executed successfully.'
        }
        failure {
            echo 'Pipeline failed — check logs for details.'
        }
    }
}
