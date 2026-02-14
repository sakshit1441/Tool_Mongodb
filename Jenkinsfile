pipeline {
    agent any

    environment {
        ANSIBLE_FORCE_COLOR       = 'true'
        ANSIBLE_HOST_KEY_CHECKING = 'False'
        AWS_DEFAULT_REGION        = 'ap-south-1'
    }

    stages {
        stage('Setup & Run Ansible') {
            steps {
                dir('Ansible') {
                    sh '''
                    # 1. Setup Environment
                    # Installing boto3 for AWS dynamic inventory support
                    sudo apt update && sudo apt install -y python3-boto3 python3-botocore

                    # Force installing the latest amazon.aws collection
                    ansible-galaxy collection install amazon.aws --force

                    # 2. Create a clean ansible.cfg
                    # Using cat <<EOF ensures no hidden characters or shell 'echo -e' interpretation issues
                    cat <<EOF > ansible.cfg
[inventory]
enable_plugins = amazon.aws.aws_ec2

[defaults]
host_key_checking = False
deprecation_warnings = False
EOF

                    # 3. Run Playbook
                    # Ensure /var/lib/jenkins/mumbai.pem exists on the server with 400 permissions
                    ansible-playbook mongodb-playbook.yml \
                      -i aws_ec2.yaml \
                      -u ubuntu \
                      --private-key /var/lib/jenkins/mumbai.pem
                    '''
                }
            }
        }
    }
}
