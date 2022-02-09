# -*- mode: ruby -*-
# vi: set ft=ruby :

#load configuration
CONFIG = YAML.load_file('config.yaml')

IMAGE = CONFIG["image"]
IP = CONFIG["ip"]
K3S_VERSION = CONFIG["version"]
CPU = CONFIG["node"]["resources"]["cpu"]
MEMORY = CONFIG["node"]["resources"]["memory"]
VM_NAME = CONFIG["node"]["name"]


Vagrant.configure("2") do |config|
    config.vm.box = "bumoad/spinbox"
    config.vm.box_version = "0.2.0"


# Kubernetes API Access
    config.vm.network "forwarded_port", guest: 6443, host: 6443
    config.vm.network "forwarded_port", guest: 9999, host: 9999
    config.vm.network "forwarded_port", guest: 9000, host: 9000
    config.vm.network "forwarded_port", guest: 8084, host: 8084
    config.vm.network "forwarded_port", guest: 80, host: 80    
    config.vm.network "private_network", ip: "192.168.56.10"
    config.vm.provider "virtualbox" do |vb|
        vb.cpus = CPU
        vb.gui = true
        vb.memory = MEMORY
        vb.name = VM_NAME
      end
    config.vm.provision "setup spinnaker", type: "shell", path: "clean.sh"
  end