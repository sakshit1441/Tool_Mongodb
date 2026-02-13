pipeline {
    agent any

    environment {
        TF_DIR = "Terraform"
        ANSIBLE_DIR = "Ansible"
        INVENTORY = "mongodb_inventory.ini"   // match Terraform-generated file
        SSH_USER = "ubuntu"
        SSH_CREDENTIAL_ID = "mongo-ssh-key"   // SSH key stored in Jenkins credentials
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

        stage('Fetch Terraform Outputs') {
            steps {
                dir("${TF_DIR}") {
                    script {
                        // Fetch Bastion and MongoDB IPs from Terraform
                        BASTION_HOST = sh(script: "terraform output -raw bastion_public_ip", returnStdout: true).trim()
                        MONGO_HOSTS = sh(script: "terraform output -json mongo_private_ips", returnStdout: true).trim()
                        echo "Bastion IP: ${BASTION_HOST}"
                        echo "MongoDB Hosts: ${MONGO_HOSTS}"
                    }
                }
            }
        }

        stage('Ansible Ping Test') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    sshagent([SSH_CREDENTIAL_ID]) {
                        sh """
                        ansible -i ${INVENTORY} mongodb -m ping \
                        -u ${SSH_USER} \
                        -o 'StrictHostKeyChecking=no'
                        """
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    sshagent([SSH_CREDENTIAL_ID]) {
                        sh """
                        ansible-playbook -i ${INVENTORY} mongo-playbook.yml \
                        -u ${SSH_USER} \
                        -o 'StrictHostKeyChecking=no'
                        """
                    }
                }
            }
        }

        stage('Deploy via Bastion SSH') {
            steps {
                sshagent([SSH_CREDENTIAL_ID]) {
                    sh """
                    ssh -A -o StrictHostKeyChecking=no -J ${SSH_USER}@${BASTION_HOST} ${SSH_USER}@${MONGO_HOSTS[0]} << 'ENDSSH'
                        echo "Connected to private MongoDB server successfully!"
                        hostname
                        whoami
                        # Add deployment commands here
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
            cleanWs() // Clean workspace after build
        }
    }
}
