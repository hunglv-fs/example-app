vậy bạn kiểm tra file Jenkinsfile có chuẩn xác chưa ? 
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
                        sh 'npm test || echo "Tests failed but continue..."'
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    script {
                        docker.image('node:18').inside {
                            sh 'npx sonar-scanner \
                                -Dsonar.projectKey=demo-app \
                                -Dsonar.sources=. \
                                -Dsonar.host.url=$SONAR_HOST_URL \
                                -Dsonar.login=$SONAR_AUTH_TOKEN'
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("$DOCKER_IMAGE:$BUILD_NUMBER")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        docker.withRegistry('', "${REGISTRY_CREDENTIALS}") {
                            docker.image("$DOCKER_IMAGE:$BUILD_NUMBER").push()
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished"
        }
        failure {
            echo "Build failed"
        }
    }
}
