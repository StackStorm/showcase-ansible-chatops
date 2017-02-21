#!/usr/bin/env bash
set -e

echo "#############################################################################################"
echo "########################### Prepare StackStorm and Ansible ##################################"

# Install ansible integration pack
st2 pack install ansible

# Install our custom pack with ansible ChatOps command aliases
st2 pack install https://github.com/armab/st2_chatops_aliases

# Needed by ansible
apt-get install -y sshpass

# cowsay via ChatOps
apt-get install -y cowsay

# Copy ansible config files from vagrant shared directory to '/etc/ansible'
st2 run ansible.command_local module_name=synchronize args='src=/vagrant/ansible/ dest=/etc/ansible'
chown -R root:root /etc/ansible
chmod -R 755 /etc/ansible
chmod 640 $(find /etc/ansible -type f)

echo "Done!"
exit 0
