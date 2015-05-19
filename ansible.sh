set -e

#  Acquire and export st2 auth token to run commands without authentication
export ST2_AUTH_TOKEN=`st2 auth testu -p testp -l 6000 | grep token | awk '{print $4}'`

echo "############################## Install st2 Ansible pack #####################################"
st2 run packs.install packs=ansible repo_url=https://github.com/armab/st2contrib.git branch=feature/ansible

echo "#############################################################################################"
echo "############################ Test Ansible Local Actions ... #################################"
echo "+-------------------------------------------------------------------------------------------+"
echo "|                             Run simple command locally                                    |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible all -c local -i '127.0.0.1,' -a 'echo \$TERM'                                      |"
echo "| ansible all --connection=local --inventory-file='127.0.0.1,' --args='echo \$TERM'          |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.command_local args='echo \$TERM'                                           |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.command_local args='echo $TERM'

echo "+-------------------------------------------------------------------------------------------+"
echo "|                         Install 'sshpass' package locally                                 |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible all -c local -i '127.0.0.1,' -m apt -a 'name=sshpass state=present'               |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.command_local module-name=apt args='name=sshpass state=present'           |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.command_local module-name=apt args='name=sshpass state=present'

echo "+-------------------------------------------------------------------------------------------+"
echo "|           Copy config files from vagrant shared directory to '/etc/ansible'               |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible all -c local -i '127.0.0.1,' \                                                    |"
echo "|   -m synchronize -a 'src=/vagrant/ansible/ dest=/etc/ansible'                             |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.command_local \                                                           |"
echo "|   module-name=synchronize args='src=/vagrant/ansible/ dest=/etc/ansible'                  |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.command_local module-name=synchronize args='src=/vagrant/ansible/ dest=/etc/ansible'
chown -R root:root /etc/ansible
chmod -R 755 /etc/ansible
chmod 640 $(find /etc/ansible -type f)


echo "#############################################################################################"
echo "############################### Test Ansible Actions ... ####################################"
echo "+-------------------------------------------------------------------------------------------+"
echo "|                      Run 'hostname -i' command on all machines                            |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible all -a 'hostname -i'                                                              |"
echo "| ansible all --args='hostname -i'                                                          |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.command hosts=all args='hostname -i'                                      |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.command hosts=all args='hostname -i'

echo "+-------------------------------------------------------------------------------------------+"
echo "|                       Ping all machines in 'nodes' group                                  |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible nodes -m ping                                                                     |"
echo "| ansible nodes --module-name=ping                                                          |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.command hosts=nodes module-name=ping                                      |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.command hosts=nodes module-name=ping

echo "+-------------------------------------------------------------------------------------------------+"
echo "|                   Uninstall 'screen' package on 'nodes', run with sudo                          |"
echo "+-------------------------------------------------------------------------------------------------+"
echo "| ansible nodes --become -m apt -a 'name=screen state=absent'                                     |"
echo "|  -->                                                                                            |"
echo "| st2 run ansible.command hosts=nodes become=true module-name=apt args='name=screen state=absent' |"
echo "+-------------------------------------------------------------------------------------------------+"
st2 run ansible.command hosts=nodes become=true module-name=apt args='name=screen state=absent'

echo "Done!"
exit 0
