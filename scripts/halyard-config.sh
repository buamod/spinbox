
#!/bin/bash
cat <<EOSTART
#######################################################
#                  spinnaker box setup                #
#######################################################
#%             Configure halyard                      $
######################################################*

EOSTART

sudo hal config version edit --version 1.26.6
sudo hal config provider kubernetes enable
sudo hal config provider kubernetes account add my-k8s \
           --provider-version v2 \
           --context $(kubectl config current-context)
sudo hal config deploy edit --type=distributed --account-name my-k8s
DEPLOYMENT="default"
sudo mkdir -p ~/.hal/$DEPLOYMENT/profiles/
echo spinnaker.s3.versioning: false > ~/.hal/$DEPLOYMENT/profiles/front50-local.yml

sudo mkdir .kube
sudo chmod 777 -R /root
sudo mkdir /root/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
sudo chmod 777 /home/vagrant/.kube/config
sudo chmod 777 /root/.kube/config
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
