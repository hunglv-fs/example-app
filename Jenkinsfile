pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'SonarQube'
        DOCKER_IMAGE = 'hunglv/demo-app'
        REGISTRY_CREDENTIALS = 'docker-hub-credentials-id'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/hunglv-fs/example-app.git', branch: 'main'
            }
        }

        stage('Install dependencies') {
            steps {
                script {
                    docker.image('node:18').inside {
                        sh 'npm install'
                    }
                }
            }
        }

        stage('Run tests') {
            steps {
                script {
                    docker.image('node:18').inside {
                        sh 'npm test' 
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SCANNER_HOME = tool 'SonarQubeScanner'
            }
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    script {
                        docker.image('node:18').inside {
                            sh """
                            npx sonar-scanner \
                                -Dsonar.projectKey=demo-app \
                                -Dsonar.projectName=demo-app \
                                -Dsonar.sources=. \
                                -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info
                            """
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("$DOCKER_IMAGE:$BUILD_NUMBER")
                    docker.image("$DOCKER_IMAGE:$BUILD_NUMBER").tag("latest")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', "${REGISTRY_CREDENTIALS}") {
                        docker.image("$DOCKER_IMAGE:$BUILD_NUMBER").push()
                        docker.image("$DOCKER_IMAGE:latest").push()
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished"
            // Clean workspace
            cleanWs()
        }
        failure {
            echo "Build failed"
            // Optional: Send notification
        }
        success {
            echo "Build succeeded!"
        }
    }
}