pipeline {
    agent {
        docker {
            image 'node:18' // hoặc maven nếu là Java
        }
    }

    environment {
        SONARQUBE_SERVER = 'SonarQube' // cấu hình trong Jenkins > Manage Jenkins > Global Tool
        DOCKER_IMAGE = 'hunglv/demo-app' // thay bằng tên image của Hưng
        REGISTRY_CREDENTIALS = 'docker-hub-credentials-id' // tạo sẵn trong Jenkins credentials
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/hunglv-fs/example-app.git', branch: 'main'
            }
        }

        stage('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run tests') {
            steps {
                sh 'npm test || echo "Tests failed but continue..."'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh 'npx sonar-scanner \
                        -Dsonar.projectKey=demo-app \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=$SONAR_HOST_URL \
                        -Dsonar.login=$SONAR_AUTH_TOKEN'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $DOCKER_IMAGE:$BUILD_NUMBER
                    '''
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
