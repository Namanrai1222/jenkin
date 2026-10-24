pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Namanrai1222/jenkin.git'
            }
        }
        stage('Build and test') {
            steps {
                sh 'mvn -B -ntp clean verify'
            }
        }
        stage('Test HTML form') {
            steps {
                sh 'python3 -m unittest discover -s tests -v'
            }
        }
    }

    post {
        always {
            junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
            archiveArtifacts allowEmptyArchive: true, artifacts: 'target/*.jar', fingerprint: true
        }
    }
}
