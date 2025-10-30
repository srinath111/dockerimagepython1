pipeline {
    agent any

    environment {
        GIT_CREDENTIALS = 'srinath111-token'
        DOCKER_REPO = 'https://github.com/srinath111/dockerimagepython1.git'
        DOCKER_HUB_CREDENTIALS= 'docker-hub'
        IMAGE_NAME = 'srinathkoraboina/python'
        IMAGE_TAG = 'l123'
        SCANNER_HOME = tool 'sonarqube'
        SONAR_HOST_URL = 'http://10.1.210.210:9005'
        SONAR_PROJECT_KEY = 'dockerimage'
        SONAR_PROJECT_NAME = 'dockerimage'
        SONAR_AUTH_TOKEN= 'sonar-token'
	
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
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh """
                        ${SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                        -Dsonar.projectName=${SONAR_PROJECT_NAME} \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=${SONAR_HOST_URL} \
                        -Dsonar.login=${SONAR_AUTH_TOKEN}
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
