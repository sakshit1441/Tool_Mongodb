pipeline {
    agent any

    environment {
        TF_DIR = "Terraform"
        ANSIBLE_DIR = "Ansible"
        INVENTORY = "inventory.ini"
        ANSIBLE_PRIVATE_KEY = "/home/jenkins/.ssh/mumbai" // path to your SSH key
        SSH_USER = "ubuntu"
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

        stage('Ansible Ping Test') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    // Test SSH connectivity to MongoDB instances via bastion
                    sh """
                        ansible -i ${INVENTORY} mongodb -m ping \
                        -u ${SSH_USER} --private-key=${ANSIBLE_PRIVATE_KEY}
                    """
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    // Run the playbook
                    sh """
                        ansible-playbook -i ${INVENTORY} playbook.yml \
                        -u ${SSH_USER} --private-key=${ANSIBLE_PRIVATE_KEY}
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
            cleanWs() // cleans workspace after build
        }
    }
}

