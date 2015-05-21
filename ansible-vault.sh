set -e

echo "#############################################################################################"
echo "############################# Test Ansible Vault Actions ... ################################"
echo "+-------------------------------------------------------------------------------------------+"
echo "|                      Encrypt screen.yml playbook with ansible-vault                       |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible-vault encrypt \                                                                   |"
echo "|   /etc/ansible/playbooks/screen.yml ---vault-password-file=/etc/ansible/vault.txt         |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.vault.encrypt \                                                           |"
echo "|   vault-password-file=/etc/ansible/vault.txt files=/etc/ansible/playbooks/screen.yml      |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.vault.encrypt vault-password-file=/etc/ansible/vault.txt files=/etc/ansible/playbooks/screen.yml


echo "+-------------------------------------------------------------------------------------------+"
echo "|    Run encrypted screen.yml playbook, which uninstalls 'screen' package on first node     |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible-playbook /etc/ansible/playbooks/screen.yml \                                      |"
echo "|   --vault-password-file=/etc/ansible/vault.txt --limit='nodes[0]'                         |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.playbook cwd=/etc/ansible \                                               |"
echo "|   playbook=playbooks/screen.yml vault-password-file=vault.txt limit='nodes[0]'            |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.playbook cwd=/etc/ansible playbook=playbooks/screen.yml vault-password-file=vault.txt limit='nodes[0]'

echo "+-------------------------------------------------------------------------------------------+"
echo "|                            Decrypt screen.yml playbook                                    |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible-vault decrypt \                                                                   |"
echo "|   /etc/ansible/playbooks/screen.yml ---vault-password-file=/etc/ansible/vault.txt         |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.vault.decrypt \                                                           |"
echo "|   cwd=/etc/ansible vault-password-file=vault.txt files=playbooks/screen.yml               |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.vault.decrypt cwd=/etc/ansible vault-password-file=vault.txt files=playbooks/screen.yml

echo "+-------------------------------------------------------------------------------------------+"
echo "|                  Replay decrypted screen.yml playbook on second node                      |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible-playbook /etc/ansible/playbooks/screen.yml --limit='nodes[1]'                     |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.playbook playbook=/etc/ansible/playbooks/screen.yml limit='nodes[1]'      |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.playbook playbook=/etc/ansible/playbooks/screen.yml limit='nodes[1]'

echo "Done!"
exit 0
