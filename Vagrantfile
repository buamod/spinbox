# -*- mode: ruby -*-
# vi: set ft=ruby :

#load configuration
CONFIG = YAML.load_file('settings.yaml')

IMAGE = CONFIG["image"]
IP = CONFIG["ip"]
K3S_VERSION = CONFIG["version"]
CPU = CONFIG["node"]["resources"]["cpu"]
MEMORY = CONFIG["node"]["resources"]["memory"]
VM_NAME = CONFIG["node"]["name"]


Vagrant.configure("2") do |config|
    config.vm.box = "bumoad/spinbox"
    config.vm.box_version = "0.3.0"


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
    config.vm.provision "install halyard", type: "shell", path: "scripts/prepare.sh"
    config.vm.provision "instasll minio-db", type: "shell", path: "scripts/db.sh"
    config.vm.provision "install k3s", type: "shell", path: "scripts/k3s.sh"
    config.vm.provision "install halyard-config", type: "shell", path: "scripts/halyard-config.sh"
    config.vm.provision "install storage-config", type: "shell", path: "scripts/storage-config.sh"
    config.vm.provision "install spinnaker", type: "shell", path: "scripts/deploy.sh"
  end