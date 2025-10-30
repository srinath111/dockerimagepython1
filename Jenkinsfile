pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = 'srinath111-token'
        DOCKER_REPO = 'https://github.com/srinath111/dockerimagepython1.git'
        DOCKER_HUB_CREDENTIALS= 'docker-hub'
        IMAGE_NAME = 'srinathkoraboina/python'
        IMAGE_TAG = 'l123'
    }

    options {
        timeout(time: 10, unit: 'MINUTES')
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo '🔹 Checking out the Python project source code...'
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: 'refs/heads/master']],
                        extensions: [[$class: 'CloneOption', depth: 1, shallow: true]],
                        userRemoteConfigs: [[
                            credentialsId: GIT_CREDENTIALS,
                            url: DOCKER_REPO
                        ]]
                    ])
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh 'docker build -t srinathkoraboina/python:l123 .'
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    input id: 'Deploy_approval', message: 'wait for approvl', ok: 'Yes, push', submitter: 'praneeth'
                    echo ' Pushing Docker image to Docker Hub...'
                    withCredentials([usernamePassword(credentialsId: DOCKER_HUB_CREDENTIALS,
                                                     usernameVariable: 'DOCKER_USER',
                                                     passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push ${IMAGE_NAME}:${IMAGE_TAG}
                            docker logout
                        """
                    }
                }
            }
        }
        stage('Clean Up Local Image') {
            steps {
                script {
                    echo ' Removing local Docker image to free up space...'
                    sh """
                        docker rmi -f ${IMAGE_NAME}:${IMAGE_TAG} || true
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Repository cloned successfully!'
        }
        failure {
            echo 'Failed to clone the repository. Please check your credentials or repo URL.'
        }
    }
}
