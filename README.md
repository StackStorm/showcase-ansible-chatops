st2 Vagrant with Ansible demo
===========

###Introduction
This is quick demonstration of the [StackStorm](http://stackstorm.com/) automation platform running with Ansible configuration management pack.

It will get you up and running with `master` VM running all St2 components as well as Ansible.
Additionally, it installs 2 nodes: `node1`, `node2` and performs ansible commands against them.

### Instructions
To provision the environment run:

    vagrant up

### Explanation
Everything below is performed as part of Vagrant provision:

* Install st2 platform and verify installation 
* Install st2 `ansible` pack from remote repository
* Copy ansible configuration files from vagrant shared directory to '/etc/ansible'
* Test `ansible.command_local` actions on local `master` machine
* Test `ansible.command` actions on both `master` and `nodes` machines

Some of the commands: 
```sh
# Run simple ansible.command locally
st2 run ansible.command_local args='echo $TERM'

# Run 'hostname -i' ansible.command on all machines (master and nodes) 
st2 run ansible.command hosts=all args='hostname -i'

# Ping all machines in 'nodes' group
st2 run ansible.command hosts=nodes module-name=ping

...
```

For more info see: [`ansible.sh`](ansible.sh), which is usual Vagrant shell provision script.
