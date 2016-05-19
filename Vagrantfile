
require 'fileutils'


# 
# Create SSH config file
#
def create_ssh_config
  ssh_config =<<__EOT__
Compression         yes
ServerAliveInterval 60

Host *
    User            vagrant
    Port            22
    IdentityFile    ./insecure_private_key

__EOT__

  $servers.each do |server|
    ssh_config = ssh_config + <<__EOT__
Host #{server[:name]} #{server[:ipaddr]}
    HostName        #{server[:ipaddr]}

__EOT__
  end
  
  File.open("ssh_config", "w") do |file|
    file.puts ssh_config
  end
end


# 
# Get shell script for provisioning
# 
def get_provision_script(server_name)
  provision_script = ''
  
  disable_selinux =<<-__EOT__
    setenforce 0
    
    sed -i 's|^SELINUX=.*$|SELINUX=disabled|g' /etc/selinux/config
    yum -y install libselinux-python
  __EOT__
  
  if server_name == 'provider'
    ansible_install =<<-__EOT__
      curl -LO http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
      rpm -ivh epel-release-6-8.noarch.rpm
      
      yum -y install ansible
    __EOT__
    
    create_local_ansible_conf_file =<<-__EOT__
      cat <<__EOD__ >~vagrant/ansible.cfg
[defaults]
inventory           = ./hosts
jinja2_extensions   = jinja2.ext.do,jinja2.ext.i18n
library             = /vagrant/ansible/library

[ssh_connection]
ssh_args            = -F ./ssh_config
__EOD__
    __EOT__
    
    create_link_to_vagrant_home =<<-__EOT__
      ln -snf /vagrant/insecure_private_key ~vagrant/
      ln -snf /vagrant/ssh_config           ~vagrant/
    __EOT__
    
    provision_script =  ansible_install +
                        create_local_ansible_conf_file +
                        create_link_to_vagrant_home
  end
  
  provision_script = provision_script + disable_selinux
  
  return provision_script
end



$servers = [
  { name: 'provider', cpus: 1, ram: '384',  ipaddr: '192.168.0.254' },
  { name: 'target',   cpus: 1, ram: '1024', ipaddr: '192.168.0.10'  },
]

create_ssh_config

$vagrant_home = ENV['VAGRANT_HOME']
$vagrant_home ||= "~/.vagrant.d"
FileUtils.cp("#{$vagrant_home}/insecure_private_key", Dir::pwd)


Vagrant.configure(2) do |config|
  config.vm.box = "centos6.7_x64"
  
  $servers.each do |server|
    config.vm.define server[:name] do |conf|
      conf.ssh.insert_key = false
      
      conf.vm.hostname = server[:name]
      conf.vm.synced_folder ".", "/vagrant", :mount_options => ['dmode=700', 'fmode=600']
      conf.vm.network :private_network, ip: server[:ipaddr]
      
      conf.vm.provider :virtualbox do |vbox|
        vbox.customize [
          'modifyvm',       :id,
          '--name',         server[:name],
          '--cpus',         server[:cpus],
          '--memory',       server[:ram],
          '--ioapic',       'on',
          '--longmode',     'on'
        ]
      end
      
      conf.vm.provision :shell, inline: get_provision_script(server[:name])
    end
  end
end
