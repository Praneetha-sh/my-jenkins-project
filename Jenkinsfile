pipeline {
    agent any 

    environment {
        // 1. CHANGE 'your-dockerhub-username' to your actual Docker Hub ID
        DOCKER_IMAGE = "your-dockerhub-username/java-hello-world"
        // 2. This MUST match the ID you created in Jenkins Credentials "Safe"
        REGISTRY_CREDS = 'docker-hub-credentials'
    }

    stages {
        stage('Clone Code') {
            steps {
                // Pulls the Main.java and Dockerfile from GitHub
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Uses your Dockerfile to compile the Java and build the image
                    echo "Building image: ${DOCKER_IMAGE}:${env.BUILD_ID}"
                    sh "docker build -t ${DOCKER_IMAGE}:${env.BUILD_ID} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Logs into Docker Hub securely and pushes the image
                    withCredentials([usernamePassword(credentialsId: env.REGISTRY_CREDS, passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                        
                        // Push with unique Build Number (e.g., version 1, 2, 3)
                        sh "docker push ${DOCKER_IMAGE}:${env.BUILD_ID}"
                        
                        // Also tag and push as 'latest' so it's easy to find
                        sh "docker tag ${DOCKER_IMAGE}:${env.BUILD_ID} ${DOCKER_IMAGE}:latest"
                        sh "docker push ${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up the local image to save space on your Jenkins server
            sh "docker rmi ${DOCKER_IMAGE}:${env.BUILD_ID} ${DOCKER_IMAGE}:latest || true"
        }
    }
}
