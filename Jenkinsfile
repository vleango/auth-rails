pipeline {
    agent {
        dockerfile {
            filename true
            args '-p 3000:3000'
            additionalBuildArgs '--build-arg APP_PATH=.'
        }
    }
    stages {
        stage('Build') {
            steps {
                echo 'hi'
            }
        }
    }
}
