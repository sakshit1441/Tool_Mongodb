pipeline {
    agent any

    environment {
        TF_DIR = "Terraform"
        ANSIBLE_DIR = "Ansible"
        INVENTORY = "mongodb_inventory.ini"   // Matches Terraform-generated file
        SSH_USER = "ubuntu"
        SSH_CREDENTIAL_ID = "mongo-ssh-key"   // SSH key stored in Jenkins credentials
        AWS_REGION = "ap-south-1"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init, Apply & Fetch Outputs') {
            steps {
                dir("${TF_DIR}") {
                    // Inject AWS credentials for all Terraform commands
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds'
                    ]]) {
                        sh '''
                            export AWS_DEFAULT_REGION=${AWS_REGION}

                            echo "Initializing Terraform..."
                            terraform init

                            echo "Applying Terraform..."
                            terraform apply -auto-approve
                        '''

                        script {
                            // Fetch Terraform outputs while AWS credentials are available
                            BASTION_HOST = sh(script: "terraform output -raw bastion_public_ip", returnStdout: true).trim()
                            MONGO_HOSTS_JSON = sh(script: "terraform output -json mongo_private_ips", returnStdout: true).trim()
                            MONGO_HOSTS = readJSON text: MONGO_HOSTS_JSON

                            echo "Bastion IP: ${BASTION_HOST}"
                            echo "MongoDB Hosts: ${MONGO_HOSTS}"
                        }
                    }
                }
            }
        }

        stage('Ansible Ping Test') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    sshagent([SSH_CREDENTIAL_ID]) {
                        sh "ansible -i ${INVENTORY} mongodb -m ping -u ${SSH_USER} -o 'StrictHostKeyChecking=no'"
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    sshagent([SSH_CREDENTIAL_ID]) {
                        sh "ansible-playbook -i ${INVENTORY} mongo-playbook.yml -u ${SSH_USER} -o 'StrictHostKeyChecking=no'"
                    }
                }
            }
        }

        stage('Deploy via Bastion SSH') {
            steps {
                sshagent([SSH_CREDENTIAL_ID]) {
                    script {
                        // Example: deploy to first MongoDB host
                        MONGO_TARGET = MONGO_HOSTS[0]
                        sh """
                        ssh -A -o StrictHostKeyChecking=no -J ${SSH_USER}@${BASTION_HOST} ${SSH_USER}@${MONGO_TARGET} << 'ENDSSH'
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
