pipeline {
    agent any

    environment {
        TF_DIR = "Terraform"
        ANSIBLE_DIR = "Ansible"
        INVENTORY = "inventory.ini"
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
                    sh 'ansible -i ${INVENTORY} mongodb -m ping'
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    sh 'ansible-playbook -i ${INVENTORY} playbook.yml'
                }
            }
        }
    }
}

