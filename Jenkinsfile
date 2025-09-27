pipeline {
    agent any

    tools {
        maven 'maven'
    }

    stages {
        stage('Build stage') {
            steps {
                sh 'mvn clean package -DskipTests'
                
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
