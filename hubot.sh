#!/usr/bin/env bash
set -e

echo "#############################################################################################"
echo "############################# Prepare Hubot and StackStorm ##################################"
# Install StackStorm hubot integration pack
st2 run packs.install packs=hubot register=all

# Install Hubot dependencies
sudo apt-get install -y build-essential redis-server

# Install Nodejs and npm
curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
sudo apt-get install -y nodejs

# Install Hubot
sudo npm install -g hubot coffee-script yo generator-hubot

# Prepare hubot installation from stanley linux user, previously created by StackStorm
# we will run chatops commands from that user
sudo mkdir -p /opt/hubot
sudo chown stanley:stanley /opt/hubot

# Generate Hubot config under /opt/hubot
sudo -H -u stanley bash -c 'cd /opt/hubot && echo "n" | yo hubot --name=stanley --description="Stanley StackStorm bot" --defaults'

# Install Slack and StackStorm plugins
sudo -H -u stanley bash -c 'cd /opt/hubot && npm install hubot-slack hubot-stackstorm --save'

# Add "hubot-stackstorm" entry into /opt/hubot/external-scripts.json file (only if it doesn't exist)
grep -q 'hubot-stackstorm' /opt/hubot/external-scripts.json || sed -i 's/.*\[.*/&\n  "hubot-stackstorm",/' /opt/hubot/external-scripts.json

# Create upstart script
cp /vagrant/hubot/hubot.conf /etc/init/hubot.conf
sudo chmod -x /etc/init/hubot.conf

# Save HUBOT_SLACK_TOKEN into /etc/init/hubot.conf if not present
grep -q "HUBOT_SLACK_TOKEN=${HUBOT_SLACK_TOKEN}" /etc/init/hubot.conf || sed -i "s/HUBOT_SLACK_TOKEN.*/HUBOT_SLACK_TOKEN=${HUBOT_SLACK_TOKEN}/" /etc/init/hubot.conf

# Start hubot
start hubot
sleep 5

# Verify if hubot is up and running
if [[ `ps aux | grep -v grep | grep hubot` ]]; then
    echo " "
    echo "All Done!"
    echo "Visit:"
    echo "http://chatops:8080/ - for StackStorm control panel"
    echo " "
    exit 0
else
    echo "ERROR!"
    echo "Something went wrong, hubot failed to start"
    exit 2
fi
