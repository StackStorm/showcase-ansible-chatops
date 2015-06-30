#!/bin/bash

#Let's set up syslog!

echo "########## Setup St2 to use Syslog ##########"
# Edit st2.conf to use syslog logging config files
sed -i "s~/logging~/syslog~" /etc/st2/st2.conf


echo "########## Turn on the UDP listener in rsyslog.conf ##########"
sed -i "s~#\$ModLoad imudp~\$ModLoad imudp~" /etc/rsyslog.conf
sed -i "s~#\$UDPServerRun 514~\$UDPServerRun 514~" /etc/rsyslog.conf

echo "########## Copy st2 Syslog config file in place ##########"
cp /vagrant/10-st2.syslog.conf /etc/rsyslog.d/

# Restart rsyslog & st2
rm -Rf /var/log/st2/*
chown -R syslog:syslog /var/log/st2
service rsyslog restart
st2ctl restart &> /dev/null
