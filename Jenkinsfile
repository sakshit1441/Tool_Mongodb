pipeline {
    agent any

    environment {
        ANSIBLE_FORCE_COLOR       = 'true'
        ANSIBLE_HOST_KEY_CHECKING = 'False'
        AWS_DEFAULT_REGION        = 'ap-south-1'
    }

    stages {
        stage('Setup Environment') {
            steps {
                sh '''
                # 1. Install necessary Python libraries
                sudo apt update && sudo apt install -y python3-boto3 python3-botocore

                # 2. Force install AWS collection
                ansible-galaxy collection install amazon.aws --force
                '''
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir('Ansible') {
                    sh '''
                    # 3. Create ansible.cfg on the fly to enable plugins
                    echo "[inventory]" > ansible.cfg
                    echo "enable_plugins = amazon.aws.aws_ec2" >> ansible.cfg
                    echo -e "\\n[defaults]" >> ansible.cfg
                    echo "host_key_checking = False" >> ansible.cfg
                    echo "deprecation_warnings = False" >> ansible.cfg

                    # 4. Run the playbook with full path to the key
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
