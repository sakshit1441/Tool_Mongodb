pipeline {
    agent any

    parameters {
        choice(
            name: 'TF_ACTION',
            choices: ['apply', 'destroy'],
            description: 'Select Terraform action'
        )
    }

    environment {
        TF_DIRECTORY       = 'Terraform'
        ANSIBLE_DIRECTORY  = 'ansible'
        AWS_DEFAULT_REGION = 'ap-south-1'

        LANG   = 'en_US.UTF-8'
        LC_ALL = 'en_US.UTF-8'
    }

    stages {

        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Infrastructure') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-keys',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    dir("${env.TF_DIRECTORY}") {
                        sh 'terraform init -input=false -migrate-state -force-copy'

                        script {
                            if (params.TF_ACTION == 'apply') {
                                sh 'terraform apply -auto-approve -input=false'
                            } else {
                                sh 'terraform destroy -auto-approve -input=false'
                            }
                        }
                    }
                }
            }
        }

        stage('Fetch Terraform Outputs') {
            when { expression { params.TF_ACTION == 'apply' } }
            steps {
                script {
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'aws-keys',
                            usernameVariable: 'AWS_ACCESS_KEY_ID',
                            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                        )
                    ]) {
                        dir("${env.TF_DIRECTORY}") {
                            env.INSTANCE_IP = sh(
                                script: "terraform output -raw private_instance_ip",
                                returnStdout: true
                            ).trim()
                        }
                    }
                }
            }
        }

        stage('Update Inventory') {
            when { expression { params.TF_ACTION == 'apply' } }
            steps {
                dir("${env.ANSIBLE_DIRECTORY}") {
                    sh "sed -i 's/INSTANCE_IP_PLACEHOLDER/${env.INSTANCE_IP}/g' inventory.ini"
                }
            }
        }

        stage('Ansible Lint') {
            when { expression { params.TF_ACTION == 'apply' } }
            steps {
                dir("${env.ANSIBLE_DIRECTORY}") {
                    sh 'ansible-lint -v mongodb-playbook.yml || true'
                }
            }
        }

        stage('MongoDB Setup via Ansible') {
            when { expression { params.TF_ACTION == 'apply' } }
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'my-server-ssh-key-v1',
                        keyFileVariable: 'SSH_KEY'
                    )
                ]) {
                    dir("${env.ANSIBLE_DIRECTORY}") {
                        sh "cp ${SSH_KEY} /tmp/mongo_key.pem && chmod 400 /tmp/mongo_key.pem"

                        sh """
                        ansible-playbook -i inventory.ini mongodb-playbook.yml \
                        --private-key=/tmp/mongo_key.pem \
                        -u ubuntu
                        """
                    }
                }
            }
        }

        stage('Verify MongoDB Service') {
            when { expression { params.TF_ACTION == 'apply' } }
            steps {
                dir("${env.ANSIBLE_DIRECTORY}") {
                    sh """
                    ansible all -i inventory.ini -m shell -a '
                        sudo systemctl status mongod || sudo systemctl status mongodb
                    ' --private-key=/tmp/mongo_key.pem -u ubuntu
                    """
                }
            }
        }
    }

    post {
        always {
            sh 'rm -f /tmp/mongo_key.pem'
        }
        success {
            echo '🎉 MongoDB Infrastructure & Setup Completed Successfully!'
        }
        failure {
            echo '❌ Pipeline Failed!'
        }
    }
}
