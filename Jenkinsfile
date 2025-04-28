pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/hunglv-fs/example-app.git', branch: 'main'
            }
        }

        stage('Check Docker Version') {
            steps {
                sh '''
                    if command -v docker >/dev/null 2>&1; then
                        echo "Docker is installed!"
                        docker --version
                    else
                        echo "Docker is NOT installed!"
                        exit 1
                    fi
                '''
            }
        }

        stage('Say Hello') {
            steps {
                sh 'echo "Hello from Jenkins!"'
            }
        }
    }

    post {
        always {
            echo "Pipeline finished!"
        }
    }
}
