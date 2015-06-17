set -e

echo "#############################################################################################"
echo "########################### Prepare StackStorm and Ansible ##################################"

# Install ansible integration pack
st2 run packs.install packs=ansible

# Install our custom pack with ansible ChatOps command aliases
st2 run packs.install packs=st2-ansible-aliases repo_url=armab/st2-ansible-aliases

# Needed by ansible
sudo apt-get install -y sshpass

# Copy ansible config files from vagrant shared directory to '/etc/ansible'
st2 run ansible.command_local module-name=synchronize args='src=/vagrant/ansible/ dest=/etc/ansible'
chown -R root:root /etc/ansible
chmod -R 755 /etc/ansible
chmod 640 $(find /etc/ansible -type f)

echo "Done!"
exit 0
