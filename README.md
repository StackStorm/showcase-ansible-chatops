Ansible ChatOps with Slack, Hubot and StackStorm - Vagrant demo
===========

### Introduction
This is quick demonstration of the [StackStorm](http://stackstorm.com/) event-driven automation platform running with [Ansible](http://ansible.com/) configuration management tool and [Hubot](https://hubot.github.com/) ChatOps engine. The objective is to operate servers with Ansible directly from [Slack](http://slack.com/) chat.

![Ansible and ChatOps with Slack and Hubot](http://i.imgur.com/HWN8T78.png)

It will get you up and running with `chatops` control VM with all St2 components prepared as well as Ansible and Hubot configured.
Additionally, it installs 2 clean Ubuntu VMs: `node1`, `node2`.

As a result you should get ready environment allowing you to execute [Ansible ad-hoc commands](http://docs.ansible.com/intro_adhoc.html) and run [Ansible playbooks](http://docs.ansible.com/playbooks.html) against VMs directly from your Slack chat.

### Getting started

#### 1. Prepare Slack
* Create [slack.com](http://slack.com/) account if you don't have it yet.
* Navigate `Configure Integrations -> Filter -> Hubot` and generate Slack & Hubot API Token.

#### 2. Vagrant up
Edit [`Vagrantfile`](Vagrantfile#L5) and place just generated API token under `HUBOT_SLACK_TOKEN` constant.
To provision the environment run:
```sh
vagrant up
```

#### 3. Try ChatOps
If you can see your bot online in Slack, you're ready to type some chat commands. Don't forget to invite your bot first into the Slack channel: `/invite <your-bot-name>`. Your first ChatOps command is: 
```
!help
```
![Ansible ChatOps with StackStorm, Hubot and Slack](http://i.imgur.com/y0Vb6jp.png)
> Additionally check the results of performed commands in StackStorm control panel:  
http://www.chatops:8080/
username: `testu`
password: `testp`

#### 4. Don't stop!
Try it, explore the internals. For configuration see: [`ansible.sh`](ansible.sh), [`hubot.sh`](hubot.sh) which are usual Vagrant shell provisioner scripts. Integrate your custom workflows and deployment mechanisms, you'll see how your work would become more efficient during time.

Feel the power of control center and may the force will be with you!

----
We're always ready to help, feel free to:
* ask questions on [IRC: #stackStorm on freenode.net](http://webchat.freenode.net/?channels=stackstorm)
* report bug, provide feature request on [GitHub st2](https://github.com/StackStorm/st2)
* share your st2 story, [email us](support@stackstorm.com)
