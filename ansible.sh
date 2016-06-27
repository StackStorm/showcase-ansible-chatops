#!/usr/bin/env bash
set -e

echo "#############################################################################################"
echo "########################### Prepare StackStorm and Ansible ##################################"

#  Acquire and export st2 auth token to run commands without authentication
export ST2_AUTH_TOKEN=`st2 auth -t testu -p testp `

# Install ansible integration pack
st2 run packs.install packs=ansible

# Install our custom pack with ansible ChatOps command aliases
st2 run packs.install packs=st2-chatops-aliases repo_url=armab/st2-chatops-aliases

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
