#!/usr/bin/env bash
set -e

echo "#############################################################################################"
echo "########################### Configure StackStorm and ChatOps ################################"

# Remove core st2 Aliases outside of this demo. Keep the ChatOps command list small
rm -rf /opt/stackstorm/packs/st2/aliases/*

ALIASES_TO_DELETE="st2.st2_actions_list st2.st2_executions_get st2.st2_executions_list \
 st2.st2_executions_re_run st2.st2_rules_list st2.st2_sensors_list packs.show_git_clone packs.pack_info"
for alias in ${ALIASES_TO_DELETE}; do
  st2 action-alias delete ${alias} > /dev/null || /bin/true
done

# Configure Hubot to use Slack (make sure we change the first occurence)
sed -i "0,/.*export HUBOT_ADAPTER.*/s/.*export HUBOT_ADAPTER.*/export HUBOT_ADAPTER=slack/" /opt/stackstorm/chatops/st2chatops.env
# Will use name 'stanley' by default, unless changed in env
sed -i "s/.*export HUBOT_NAME.*/export HUBOT_NAME=${HUBOT_NAME}/" /opt/stackstorm/chatops/st2chatops.env
# Public URL of StackStorm instance: used it to offer links to execution details in a chat
sed -i "s/.*export ST2_WEBUI_URL.*/export ST2_WEBUI_URL=https:\/\/`hostname`/" /opt/stackstorm/chatops/st2chatops.env

# Install hubot-shipit
cd /opt/stackstorm/chatops && sudo npm install hubot-shipit --save
grep -q 'hubot-shipit' /opt/stackstorm/chatops/external-scripts.json || sed -i 's/.*\[.*/&\n  "hubot-shipit",/' /opt/stackstorm/chatops/external-scripts.json

# Wipe st2chatops logs before checking for service readiness
[ -f /var/log/st2/st2chatops.log ] && > /var/log/st2/st2chatops.log

# Restart Chatops
service st2chatops restart

# Wait 30 seconds for Hubot to start
for i in {1..30}; do
    ACTIONEXIT=`grep -q 'INFO Connected to Slack' /var/log/st2/st2chatops.log && grep -q 'INFO [[:digit:]]\+ commands are loaded' /var/log/st2/st2chatops.log 2> /dev/null; echo $?`
    if [ ${ACTIONEXIT} -eq 0 ]; then
        break
    fi
    sleep 1
done

# Verify if Chatops is up and running
if [ ${ACTIONEXIT} -eq 0 ]; then
    st2 run chatops.post_message channel=general message='To get a list of commands type: ```!help```' extra='{"slack": {"color":"#f48527","pretext":"Hey <!channel>, Ready for ChatOps?","title": "Ansible and ChatOps. Get started :rocket:","title_link":"https://stackstorm.com/2015/06/24/ansible-chatops-get-started-%f0%9f%9a%80/","author_name":"by StackStorm - IFTTT for Ops","author_link":"https://stackstorm.com/","author_icon":"https://stackstorm.com/wp/wp-content/uploads/2015/01/favicon.png","image_url":"https://i.imgur.com/HWN8T78.png","fields":[{"title":"Documentation","value":"https://docs.stackstorm.com/chatops/","short":true}]}}' > /dev/null
    st2 run chatops.post_message channel=general message='*Warning!* You might have fun: https://www.youtube.com/watch?v=IhzxnY7FIvg {~}' > /dev/null
    echo " "
    echo "#############################################################################################"
    echo "###################################### All Done! ############################################"
    echo " "
    echo "Your bot should be online in Slack now. Your first ChatOps command:"
    echo "!help"
    echo " "
    echo " "
    echo "Visit:"
    echo "https://www.chatops/ - for StackStorm control panel"
    echo "Username: demo"
    echo "Password: demo"
    echo " "
    exit 0
else
    echo " "
    echo "#############################################################################################"
    echo "####################################### ERROR! ##############################################"
    echo " "
    echo "Something went wrong, hubot failed to start"
    echo "Check /var/log/st2/st2chatops.log for more info"
    echo " "
    exit 2
fi
