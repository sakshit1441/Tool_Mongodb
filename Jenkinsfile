pipeline {
    agent any

    environment {
        ANSIBLE_FORCE_COLOR       = 'true'
        ANSIBLE_HOST_KEY_CHECKING = 'False'
        AWS_DEFAULT_REGION        = 'ap-south-1'
        SLACK_CHANNEL             = '#notifications'
    }

    stages {

        stage('Workspace Check') {
            steps {
                sh '''
                echo "Workspace path:"
                pwd
                echo "Repo content:"
                ls -l
                '''
            }
        }

        stage('Verify Ansible ') {
            steps {
                dir('Ansible') {
                    sh '''
                    echo "Inside Ansible"
                    pwd
                    ls -l
                    '''
                }
            }
        }

        stage('Ansible Syntax Check') {
            steps {
                dir('Ansible') {
                    sh '''
                    export LANG=en_US.UTF-8
                    export LC_ALL=en_US.UTF-8

                    echo "Running Ansible Syntax Check..."
                    ansible-playbook mongodb-playbook.yml \
                      -i aws_ec2.yaml \
                      --syntax-check
                    '''
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir('Ansible') {
                    sh '''
                    export LANG=en_US.UTF-8
                    export LC_ALL=en_US.UTF-8

                    echo "Running Ansible Playbook..."
                    ansible-playbook mongodb-playbook.yml \
                      -i aws_ec2.yaml \
                      -u ubuntu \
                      --private-key ~/.ssh/mumbai.pem
                    '''
                }
            }
        }
    }
}
