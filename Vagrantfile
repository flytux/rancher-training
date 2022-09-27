# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "vm01" do |node|
    node.vm.box = "opensuse/Leap-15.3.x86_64"
    node.vm.hostname = "vm01"

    node.vm.provider "libvirt" do |lv|
      lv.memory = "8192"
      lv.cpus = "6"
    end
  
    node.vm.provision "shell", inline: <<-SHELL
    sudo zypper in -y docker git

    sudo systemctl enable docker
    sudo systemctl start docker

    sudo usermod -aG docker vagrant
    newgrp docker
    SHELL

  end
end
