#!/usr/bin/env bash
set -e

echo "#############################################################################################"
echo "##################################### Prepare db VM #########################################"

apt-get update
# Install MySQL, set root password to 'PASS'
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mysql-server mysql-server/root_password password PASS'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password PASS'
apt-get install -y mysql-server

# Enable `mysql` autologin for `root` linux user
touch ~/.my.cnf
chmod 0640 ~/.my.cnf
echo -e '[client]
user=root
password=PASS' > ~/.my.cnf

# Verify mysql installation
mysql --execute='SHOW PROCESSLIST;' > /dev/null || (echo 'Error! MySQL command failed' && exit 1)

echo "Done!"
exit 0
