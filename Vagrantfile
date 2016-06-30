# -*- mode: ruby -*-
# vi: set ft=ruby :

# Set Hubot Slack Token here
HUBOT_SLACK_TOKEN = ENV['HUBOT_SLACK_TOKEN'] ? ENV['HUBOT_SLACK_TOKEN'] : ''
HUBOT_NAME = ENV['HUBOT_NAME'] ? ENV['HUBOT_NAME'] : 'stanley'

VIRTUAL_MACHINES = {
  :web => {
    :ip => '192.168.90.61',
    :hostname => 'web',
  },
  :db => {
    :ip => '192.168.90.62',
    :hostname => 'db',
  },
  :chatops => {
    :ip => '192.168.90.60',
    :hostname => 'chatops',
  },
}

# Autoinstall for vagrant-hostmanager plugin
# See https://github.com/smdahlen/vagrant-hostmanager
unless Vagrant.has_plugin?('vagrant-hostmanager')
  system('vagrant plugin install vagrant-hostmanager') || exit!
  exit system('vagrant', *ARGV)
end
Vagrant.configure(2) do |config|
  # Global configuration for all boxes
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.hostmanager.enabled = false
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  # VM specific configurations
  VIRTUAL_MACHINES.each do |name, cfg|
    config.vm.define name do |vm_config|
      vm_config.vm.box = 'ubuntu/trusty64'
      vm_config.vm.hostname = cfg[:hostname]
      vm_config.hostmanager.aliases = "www.#{cfg[:hostname]}"
      vm_config.vm.network :private_network, ip: cfg[:ip]

      vm_config.vm.provider :virtualbox do |vb|
        vb.name = cfg[:hostname]
      end

      if Vagrant.has_plugin?('vagrant-cachier')
        vm_config.cache.scope = :box
      end

      vm_config.vm.provision :hostmanager

      if name == :web
        vm_config.vm.provision :shell, :path => "web.sh"
      end

      if name == :db
        vm_config.vm.provision :shell, :path => "db.sh"
      end

      # Additional rules for chatops server
      if name == :chatops
        vm_config.vm.provider :virtualbox do |vb|
          vb.memory = 2048
        end
        # Start shell provisioning for chatops server
        vm_config.vm.provision :shell,
          # Use `privileged: false`, the script is initially executed from the `vagrant` user, `sudo`-ing when needed
          # Allows to set StackStorm credentials for both `vagrant` and `root` users in `~/.st2`
          privileged: false,
          path: "https://stackstorm.com/packages/install.sh",
          args: [
            '--user=demo',
            '--password=demo'
          ],
          env: {
            'HUBOT_SLACK_TOKEN' => "#{HUBOT_SLACK_TOKEN}"
          }
        vm_config.vm.provision :shell, path: "ansible.sh"
        vm_config.vm.provision :shell, path: "chatops.sh", env: {'HUBOT_NAME' => "#{HUBOT_NAME}"}
      end
    end
  end
end
