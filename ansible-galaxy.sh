#!/bin/bash

set -e

echo "#############################################################################################"
echo "############################ Test Ansible Galaxy Actions ... ################################"
echo "+-------------------------------------------------------------------------------------------+"
echo "|                    Download 'composer' role from Ansible Galaxy                           |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible-galaxy install kosssi.composer                                                    |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.galaxy.install roles=kosssi.composer                                      |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.galaxy.install roles=kosssi.composer

echo "+-------------------------------------------------------------------------------------------+"
echo "|                    List installed roles from Ansible Galaxy                               |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible-galaxy list                                                                       |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.galaxy.list                                                               |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.galaxy.list

echo "+-------------------------------------------------------------------------------------------+"
echo "|              Remove previously installed 'composer' role from Ansible Galaxy              |"
echo "+-------------------------------------------------------------------------------------------+"
echo "| ansible-galaxy remove kosssi.composer                                                     |"
echo "|  -->                                                                                      |"
echo "| st2 run ansible.galaxy.remove roles=kosssi.composer                                       |"
echo "+-------------------------------------------------------------------------------------------+"
st2 run ansible.galaxy.remove roles=kosssi.composer

echo "Done!"
exit 0
