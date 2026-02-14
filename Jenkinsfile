stage('Run Ansible Playbook') {
    steps {
        dir('Ansible') {
            sh '''
            # 1. Config file create karo (Inventory parsing ke liye)
            echo -e "[inventory]\nenable_plugins = amazon.aws.aws_ec2\n\n[defaults]\nhost_key_checking = False" > ansible.cfg

            # 2. Dependency ensure karo
            ansible-galaxy collection install amazon.aws

            # 3. Playbook run karo
            ansible-playbook mongodb-playbook.yml \
              -i aws_ec2.yaml \
              -u ubuntu \
              --private-key /var/lib/jenkins/mumbai.pem
            '''
        }
    }
}
