pipeline {
    agent any

    environment {
        TF_DIR = "Terraform"
        ANSIBLE_DIR = "Ansible"
        INVENTORY = "inventory.ini"
        SSH_USER = "ubuntu"
        BASTION_HOST = "13.126.235.185"
        PRIVATE_HOST = "10.0.11.137"
        SSH_CREDENTIAL_ID = "mongo-ssh-key" // Correct Jenkins SSH credential ID
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    withAWS(credentials: 'aws-creds', region: 'ap-south-1') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_DIR}") {
                    withAWS(credentials: 'aws-creds', region: 'ap-south-1') {
                        sh 'terraform plan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_DIR}") {
                    withAWS(credentials: 'aws-creds', region: 'ap-south-1') {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Ansible Ping & Playbook') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    sshagent([SSH_CREDENTIAL_ID]) {
                        sh "ansible -i ${INVENTORY} mongodb -m ping -u ${SSH_USER}"
                        sh "ansible-playbook -i ${INVENTORY} playbook.yml -u ${SSH_USER}"
                    }
                }
            }
        }

        stage('Deploy via Bastion SSH') {
            steps {
                sshagent([SSH_CREDENTIAL_ID]) {
                    sh """
                    ssh -A -o StrictHostKeyChecking=no -J ${SSH_USER}@${BASTION_HOST} ${SSH_USER}@${PRIVATE_HOST} << 'ENDSSH'
                        echo "Connected to private server successfully!"
                        hostname
                        whoami
                        # Add your deployment commands here
                    ENDSSH
                    """
                }
            }
        }

    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs above for errors.'
        }
        always {
            cleanWs()
        }
    }
}

