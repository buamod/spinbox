# -*- mode: ruby -*-
# vi: set ft=ruby :

#load configuration
CONFIG = YAML.load_file('settings.yaml')

VAGRANT_VERSION =  CONFIG["vagrant_version"]
K3S_VERSION =  CONFIG["k3s_version"]
KUBECONFIG_MODE = CONFIG["kubeconfig_mode"]
DB_USER =  CONFIG["db"]["user"]
DB_PASSWORD = CONFIG["db"]["password"]
DB_PORT = CONFIG["db"]["port"]
IMAGE = CONFIG["image"]
IMAGE_VERSION = CONFIG["image_version"]
IP = CONFIG["ip"]
K3S_VERSION = CONFIG["version"]
CPU = CONFIG["node"]["resources"]["cpu"]
MEMORY = CONFIG["node"]["resources"]["memory"]
VM_NAME = CONFIG["node"]["name"]
GUI = CONFIG["node"]["gui"]



#https://github.com/hashicorp/vagrant/issues/7015
$set_environment_variables = <<SCRIPT
tee "/etc/profile.d/myvars.sh" > "/dev/null" <<EOF

# k3s environment varaibles.
export K3S_VERSION=#{K3S_VERSION}
export KUBECONFIG_MODE=#{KUBECONFIG_MODE}

# minio environment variables.
export MINIO_ROOT_USER=#{DB_USER}
export MINIO_ROOT_PASSWORD=#{DB_PASSWORD}
export MINIO_PORT=#{DB_PORT}
EOF
SCRIPT

Vagrant.configure(VAGRANT_VERSION) do |config|
    config.vm.box = IMAGE
    config.vm.box_version = IMAGE_VERSION

    config.vm.network "forwarded_port", guest: 6443, host: 6443
    config.vm.network "forwarded_port", guest: 9999, host: 9999
    config.vm.network "forwarded_port", guest: 9000, host: 9000
    config.vm.network "forwarded_port", guest: 8084, host: 8084
    config.vm.network "forwarded_port", guest: 80, host: 80    
    config.vm.network "private_network", ip: IP
    config.vm.provider "virtualbox" do |vb|
        vb.cpus = CPU
        vb.gui = GUI
        vb.memory = MEMORY
        vb.name = VM_NAME
      end
    config.vm.provision "shell", inline: $set_environment_variables, run: "always"
    config.vm.provision "prepare node", type: "shell", path: "scripts/prepare.sh"
    config.vm.provision "instasll minio-db", type: "shell", path: "scripts/db.sh"
    config.vm.provision "install k3s", type: "shell", path: "scripts/k3s.sh"
    config.vm.provision "install halyard-config", type: "shell", path: "scripts/halyard-config.sh"
    config.vm.provision "install storage-config", type: "shell", path: "scripts/storage-config.sh"
    config.vm.provision "install spinnaker", type: "shell", path: "scripts/deploy.sh"
  end