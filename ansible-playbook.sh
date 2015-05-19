set -e

echo "#############################################################################################"
echo "########################### Test Ansible Playbook Actions ... ###############################"
echo "+-------------------------------------------------------------------------------------------+"
echo "|                  Run nginx.yml playbook on all machines (installs nginx)                  |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible-playbook /etc/ansible/playbooks/nginx.yml                                         |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.playbook playbook=/etc/ansible/playbooks/nginx.yml                        |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.playbook playbook=/etc/ansible/playbooks/nginx.yml


echo "+-------------------------------------------------------------------------------------------+"
echo "|        Replay nginx.yml playbook, set extra var to change nginx welcome message           |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible-playbook /etc/ansible/playbooks/nginx.yml extra-vars='welcome_name=Stanley'       |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.playbook \                                                                |"
echo "|   playbook=/etc/ansible/playbooks/nginx.yml extra-vars='welcome_name=Stanley'             |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.playbook playbook=/etc/ansible/playbooks/nginx.yml extra-vars='welcome_name=Stanley'


echo "+-------------------------------------------------------------------------------------------+"
echo "|               Let the last node machine greet your cat via nginx                          |"
echo "|               Visit: http://node2/                                                        |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible-playbook /etc/ansible/playbooks/nginx.yml                                         |"
echo "|   extra-vars='welcome_name=cat' --limit='nodes[1]'                                        |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.playbook playbook=/etc/ansible/playbooks/nginx.yml \                      |"
echo "|   extra-vars='welcome_name=cat' limit='nodes[-1]'                                         |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.playbook playbook=/etc/ansible/playbooks/nginx.yml extra-vars='welcome_name=cat' limit='nodes[-1]'


echo "All Done!"
echo " "
echo "Visit:"
echo "http://master/"
echo "http://node1/"
echo "http://node2/"
echo " "
echo "http://master:8080/ - for StackStorm control panel"
exit 0
