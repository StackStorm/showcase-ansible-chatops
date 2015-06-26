Ansible & ChatOps with Slack, Hubot and StackStorm - Vagrant demo
===========
> Part of tutorial: [Ansible and ChatOps. Get started :rocket:](http://stackstorm.com/2015/06/24/ansible-chatops-get-started-%f0%9f%9a%80/)

### Introduction
This is quick demonstration of the [StackStorm](http://stackstorm.com/) event-driven automation platform running with [Ansible](http://ansible.com/) configuration management tool and [Hubot](https://hubot.github.com/) ChatOps engine. The objective is to operate servers with Ansible directly from [Slack](http://slack.com/) chat.

![Ansible and ChatOps with Slack and Hubot](http://i.imgur.com/HWN8T78.png)

It will get you up and running with `chatops` control VM with all St2 components prepared as well as Ansible and Hubot configured.
Additionally, it installs 2 Ubuntu VMs: `web` server with nginx and `db` server with mysql.

As a result you should get 100% ready environment allowing you to execute [Ansible ad-hoc commands](http://docs.ansible.com/intro_adhoc.html) and run [Ansible playbooks](http://docs.ansible.com/playbooks.html) against VMs directly from your Slack chat. In this showcase we already crafted some simple, but useful real world ChatOps commands.

### Getting started

#### 1. Prepare Slack
* Create [slack.com](http://slack.com/) account if you don't have it yet.
* Navigate `Configure Integrations -> Filter -> Hubot` and generate Slack & Hubot API Token.

#### 2. Vagrant up
Edit [`Vagrantfile`](Vagrantfile#L5) and place just generated API token under `HUBOT_SLACK_TOKEN` constant, or just export it:
```sh
export HUBOT_SLACK_TOKEN=xoxb-1234-5678-91011-00e4dd
```

To provision the environment run:
```sh
vagrant up
```
Installation takes some time (st2 engine comes with Python, RabbitMQ, PostgreSQL, MongoDB, OpenStack Mistral).

#### 3. Try ChatOps
You should see your bot online in Slack and now you're ready to type some chat commands. Don't forget to invite your bot into the Slack channel: `/invite <your-bot-name>`. Your first ChatOps command is: 
```
!help
```
![Ansible ChatOps with StackStorm, Hubot and Slack. List of ChatOps commands](http://i.imgur.com/bspyYZ7.png)
Full list of available commands from [st2-chatops-aliases](https://github.com/armab/st2-chatops-aliases) pack:
* [`!ansible {{args}}`](http://i.imgur.com/pk3xouo.png) - Run ansible command on local machine
* [`!status {{hosts}}`](http://i.imgur.com/fak6ZP7.png) - Show status for hosts (ansible ping module)
* [`!show nginx stats on {{hosts}}`](http://i.imgur.com/Sc5wm7m.png) - Show sorted http status codes from nginx on hosts
* [`!show mysql processlist {{hosts=db}}`](http://i.imgur.com/6YNy3GJ.png) - Show MySQL processlist
* [`!service restart {{service_name}} on {{hosts}}`](http://i.imgur.com/xVyl6xW.png) - Restart service on remote hosts
* [`!show version {{package}} on {{hosts}}`](http://i.imgur.com/RnUqEUb.png) - Show package versions on hosts
* [`!update {{package}} on {{hosts}}`](http://i.imgur.com/IT2EDcn.png) - Update package on remote hosts
* [`!cowsay {{message}}`](http://i.imgur.com/ziIh0sZ.png) - Draws a cow that says what you want

> Additionally check the results of performed commands in StackStorm control panel:  
http://www.chatops:8080/
username: `testu`
password: `testp`

#### 4. Don't stop!
Try it, explore the internals. For configuration see: [`ansible.sh`](ansible.sh), [`hubot.sh`](hubot.sh) which are usual Vagrant shell provisioner scripts.
Integrate your custom workflows and deployment mechanisms, you'll see how your work becomes more efficient during time.

Feel the power of control center and may the force will be with you!

----
We're always ready to help, feel free to:
* ask questions on [IRC: #stackStorm on freenode.net](http://webchat.freenode.net/?channels=stackstorm) or our [public Slack](https://stackstorm.typeform.com/to/K76GRP)
* report bug, provide feature request or just give us a ✮ star at [GitHub st2](https://github.com/StackStorm/st2)
* share your st2 story, [email us](mailto:support@stackstorm.com)
