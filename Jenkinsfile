pipeline {
    agent any

    tools {
        maven 'maven'
    }

    environment {
        DOCKER_IMAGE = 'abhi539/spring_kannada_poets'
        CONTAINER_NAME = 'spring_kannada_poets_container'
        APP_PORT = '8080'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Checking out the latest code from GitHub..."
                checkout scm
            }
        }

        stage('Build WAR') {
            steps {
                echo "Building the project using Maven..."
                sh 'mvn clean package -DskipTests'
            }
            post {
                success {
                    echo 'WAR file built successfully.'
                }
                failure {
                    echo 'WAR file build failed.'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh 'sudo docker build -t $DOCKER_IMAGE:latest .'
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

        stage('Docker Login') {
            steps {
                echo "Logging into DockerHub..."
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

        stage('Push Docker Image') {
            steps {
                echo "Pushing image to DockerHub..."
                sh 'sudo docker push $DOCKER_IMAGE:latest'
            }
            post {
                success {
                    echo 'Image pushed to DockerHub successfully.'
                }
                failure {
                    echo 'Failed to push Docker image.'
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    echo "Checking for existing container..."
                    def containerExists = sh(
                        script: "sudo docker ps -a --format '{{.Names}}' | grep -w $CONTAINER_NAME || true",
                        returnStdout: true
                    ).trim()
                    if (containerExists) {
                        echo "Container already exists."
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
                                sudo docker run -d -p 8084:8080 --name $CONTAINER_NAME $DOCKER_IMAGE:latest
                            '''
                        } else {
                            echo "Skipping redeployment as per user choice."
                        }
                    } else {
                        echo "Starting new container..."
                        sh 'sudo docker run -d -p 8084:8080 --name $CONTAINER_NAME $DOCKER_IMAGE:latest'
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
        success {
            echo 'Pipeline succeeded.'
        }
        failure {
            echo 'Pipeline failed. Check logs for errors.'
        }
    }
}
