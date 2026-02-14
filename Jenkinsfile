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
                            // Use 'def' for Groovy variables to avoid warnings
                            def bastionHost = sh(script: "terraform output -raw bastion_public_ip", returnStdout: true).trim()
                            def mongoHostsJson = sh(script: "terraform output -json mongo_private_ips", returnStdout: true).trim()
                            def mongoHosts = readJSON text: mongoHostsJson

                            echo "Bastion IP: ${bastionHost}"
                            echo "MongoDB Hosts: ${mongoHosts}"

                            // Save to environment for other stages
                            env.BASTION_HOST = bastionHost
                            env.MONGO_HOSTS = mongoHosts.join(',')
                        }
                    }
                }
            }
        }

        stage('Ansible Ping Test') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    sshagent([SSH_CREDENTIAL_ID]) {
                        // Remove invalid -o; inventory already has SSH options
                        sh "ansible -i ${INVENTORY} mongodb -m ping -u ${SSH_USER}"
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    sshagent([SSH_CREDENTIAL_ID]) {
                        sh "ansible-playbook -i ${INVENTORY} mongo-playbook.yml -u ${SSH_USER}"
                    }
                }
            }
        }

        stage('Deploy via Bastion SSH') {
            steps {
                sshagent([SSH_CREDENTIAL_ID]) {
                    script {
                        // Get the first MongoDB host from env variable
                        def mongoTarget = env.MONGO_HOSTS.split(',')[0]
                        sh """
                        ssh -A -o StrictHostKeyChecking=no -J ${SSH_USER}@${BASTION_HOST} ${SSH_USER}@${mongoTarget} << 'ENDSSH'
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
