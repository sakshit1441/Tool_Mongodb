pipeline {
    agent any

    environment {
        ANSIBLE_FORCE_COLOR       = 'true'
        ANSIBLE_HOST_KEY_CHECKING = 'False'
        AWS_DEFAULT_REGION        = 'ap-south-1'
    }

    stages {
        stage('Ansible Syntax Check') {
            steps {
                dir('Ansible') {
                    sh 'ansible-playbook mongodb-playbook.yml -i aws_ec2.yaml --syntax-check'
                }
            }
        }
        stage('Run Playbook') {
            steps {
                dir('Ansible') {
                    // Yahan aapko apni .pem key provide karni hogi
                    sh 'ansible-playbook mongodb-playbook.yml -i aws_ec2.yaml -u ubuntu --private-key ~/.ssh/mumbai.pem'
                }
            }
        }
    }
}
