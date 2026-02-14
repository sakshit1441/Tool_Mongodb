pipeline {
    agent any

    environment {
        ANSIBLE_FORCE_COLOR       = 'true'
        ANSIBLE_HOST_KEY_CHECKING = 'False'
        AWS_DEFAULT_REGION        = 'ap-south-1'
    }

    stages {
        stage('Workspace Check') {
            steps {
                sh 'ls -l'
            }
        }

        stage('Ansible Syntax Check') {
            steps {
                dir('Ansible') {
                    // IAM role automatically credentials handle kar lega
                    sh 'ansible-playbook mongodb-playbook.yml -i aws_ec2.yaml --syntax-check'
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir('Ansible') {
                    // Note: .pem file ka path wahi dena jahan Jenkins user usse read kar sake
                    sh 'ansible-playbook mongodb-playbook.yml -i aws_ec2.yaml -u ubuntu --private-key /var/lib/jenkins/mumbai.pem'
                }
            }
        }
    }
}
