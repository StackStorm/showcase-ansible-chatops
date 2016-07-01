#!/usr/bin/env bash
set -e

# Moved this check here out of Vagrantfile so it's only executed on provisioning
#if [[ "$HUBOT_SLACK_TOKEN" != "xoxb"* ]]
# then
#    echo "Error! HUBOT_SLACK_TOKEN is required."
#    echo "Please specify it in your environment, e.g.:"
#    echo "export HUBOT_SLACK_TOKEN=xoxb-5187818172-I7wLh4oqzhAScwXZtPcHyxCu"
#    exit 1
#fi

echo "#############################################################################################"
echo "############################ Configure Hubot and StackStorm #################################"

# Configure Hubot to use Slack
sed -i "s~# export HUBOT_ADAPTER=slack~export HUBOT_ADAPTER=slack~" /opt/stackstorm/chatops/st2chatops.env

# Will use name 'stanley' by default, unless changed in env
sed -i "s~export HUBOT_NAME=hubot~export HUBOT_NAME=${HUBOT_NAME}~" /opt/stackstorm/chatops/st2chatops.env

# Start Chatops
st2ctl restart st2chatops

# Wait 30 seconds for Hubot to start
for i in {1..30}; do
    ACTIONEXIT=`grep -q 'Slack client now connected' /var/log/st2/st2chatops.log 2> /dev/null; echo $?`
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
    echo "https://chatops/ - for StackStorm control panel"
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
