pipeline {
    agent any

    environment {
        IMAGE_NAME = "spring-kannada-poets"
        DOCKERHUB_REPO = "abhilashappi/spring-kannada-poets"
    }

    stages {

        stage('Checkout Source') {
            steps {
                echo 'Checking out source code...'
                git branch: 'master', url: 'https://github.com/Abhilashappi/spring_kannada_poets.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the project...'
                sh 'mvn clean package -DskipTests'
                echo 'Build stage completed successfully.'
            }
        }

        stage('Docker Build the Image') {
            steps {
                echo 'Building the Docker image...'
                sh 'docker build -t ${IMAGE_NAME}:latest .'
                echo 'Docker image built successfully.'
            }
        }

        stage('Docker Login to DockerHub') {
            steps {
                echo 'Logging in to DockerHub...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                }
            }
        }

        stage('Docker Tag the Image') {
            steps {
                echo 'Tagging Docker image...'
                sh 'docker tag ${IMAGE_NAME}:latest ${DOCKERHUB_REPO}:latest'
            }
        }

        stage('Docker Push the Image') {
            steps {
                echo 'Pushing Docker image to DockerHub...'
                sh 'docker push ${DOCKERHUB_REPO}:latest'
            }
        }

        stage('Cleanup Local Docker Images') {
            steps {
                echo 'Cleaning up local Docker images...'
                sh 'docker rmi ${IMAGE_NAME}:latest || true'
                sh 'docker rmi ${DOCKERHUB_REPO}:latest || true'
            }
        }

        stage('Done') {
            steps {
                echo '✅ Pipeline completed successfully!'
            }
        }
    }

    post {
        failure {
            echo '❌ Pipeline failed — check logs for details.'
        }
        success {
            echo '✅ Pipeline finished successfully.'
        }
    }
}
