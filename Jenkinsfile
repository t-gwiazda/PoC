pipeline {
    agent any

    stages {
        stage('Build Environment'){
            steps {
                echo 'Building environment'
                sh 'PATH=$PATH:/usr/local/bin'
                sh 'terraform init'
                sh 'terraform plan -out planfile'
                sh 'terraform apply planfile'
            }
        }
        stage('Sleep for 2 minutes'){
            steps {
                echo 'Waiting for 2 minutes before cleanup'
                sleep(120)
            }
        }
        stage('Destroy environment') {
            steps {
                echo 'Destroying environment'
                sh 'terraform destroy --auto-approve'
            }
        }
    }
}

