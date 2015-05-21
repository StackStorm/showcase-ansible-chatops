StackStorm with Ansible on Vagrant demo
===========

###Introduction
This is quick demonstration of the [StackStorm](http://stackstorm.com/) automation platform running with Ansible configuration management pack.

It will get you up and running with `master` VM running all St2 components as well as Ansible.
Additionally, it installs 2 clean Ubuntu VMs: `node1`, `node2` and performs ansible commands against them.

### Instructions
To provision the environment run:

    vagrant up

> Check the results of performed commands in StackStorm control panel:  
http://www.master:8080/
username: `testu`
password: `testp`

Don't forget to visit: 
* http://www.master/
* http://www.node1/
* http://www.node2/

### Explanation
Everything below is performed as part of Vagrant provision:

* Install st2 platform and verify installation 
* Install st2 `ansible` pack from remote repository
* Copy ansible configuration files from vagrant shared directory into '/etc/ansible' on `master`
* Test `ansible.command_local` actions ([ad-hoc](http://docs.ansible.com/intro_adhoc.html) ansible command) against local `master` machine
* Test `ansible.command` actions ([ad-hoc](http://docs.ansible.com/intro_adhoc.html) ansible command) against both local `master` and remote `node1` `node2` machines
* Test `ansible.galaxy` actions, install, list and then remove roles installed from [Ansible Galaxy](https://galaxy.ansible.com/)
* Test `ansible.vault` actions, encrypt/decrypt playbooks and run them
* Test `ansible.playbook` action, run [nginx.yml playbook](ansible/playbooks/nginx.yml) against all machines
* Let the nginx on latest node greet your cat (what?!), have fun

Some of the commands: 
```sh
# Run simple ansible.command locally
st2 run ansible.command_local args='echo $TERM'

# Run 'hostname -i' ansible.command on all machines (master and nodes) 
st2 run ansible.command hosts=all args='hostname -i'

# Ping all machines in 'nodes' group
st2 run ansible.command hosts=nodes module-name=ping

# Install nginx via playbook on all machines 
st2 run ansible.playbook playbook=/etc/ansible/playbooks/nginx.yml

# Run nginx playbook on latest node machine, set nginx index.html welcome message
st2 run ansible.playbook playbook=/etc/ansible/playbooks/nginx.yml extra-vars='welcome_name=Tom' limit='nodes[-1]'

...
```

For all commands executed see: [`ansible.sh`](ansible.sh), [`ansible-galaxy.sh`](ansible-galaxy.sh), [`ansible-vault.sh`](ansible-vault.sh) and [`ansible-playbook.sh`](ansible-playbook.sh),
which are usual Vagrant shell provisioner scripts.
