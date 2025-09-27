pipeline {
    agent any

    tools {
        maven 'maven'
    }

    stages {
        stage('Build stage') {
            steps {
                sh 'mvn clean package'
            }
        }
    }

    post {
        success {
            echo '✅ Build succeeded'
        }
        failure {
            echo '❌ Build failed'
        }
    }
}
