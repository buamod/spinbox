
#!/bin/bash
cat <<EOSTART
#######################################################
#                  spinnaker box setup                #
#######################################################
# DEFAULTS:                                           ~
#%          1- Install K3s                            !             
#%          2- Install docker                         @
#%          3- Install openjdk 11                     #
#%          4- Set create new user                    $ 
#%          5- Set MINIO ENVs and JAVA_HOME           %
#%          6- Install Halyard                        ^
#%          7- Start the MINIO container              &
#%          8- Configure hal version list             *
#%          9- Configure hal version and storage     ()
#%          10- Configure kubectl to k3s kubectl      _  
#%          - INSTALL                                 +
#######################################################

EOSTART
docker run hello-world
echo $JAVA_HOME
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minioadmin
MINIO_PORT="9010"
export MINIO_ROOT_USER=minioadmin
export MINIO_ROOT_PASSWORD=minioadmin
export MINIO_PORT="9010"

echo "#######################################################"
echo "install k3s"
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.9+k3s1 K3S_KUBECONFIG_MODE="644" sh -

curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh && \
sudo chmod +x ./InstallHalyard.sh && \
sudo bash InstallHalyard.sh --user ibrahim -y
. /home/ibrahim/.bashrc

echo "#######################################################"
echo "start DB"
sudo docker run -it -d --rm -v ~/.minio-data/:/data --name minio-4-spinnaker -p ${MINIO_PORT}:${MINIO_PORT} \
 -e MINIO_ROOT_USER=${MINIO_ROOT_USER} -e  MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD} \
 minio/minio@sha256:69c5be1eb4f7964fa2227b0f2c19126f95a7fb8ea9cfc7cc8c25d8a483aa7748 server /data --address :${MINIO_PORT}
ENDPOINT=http://$(sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' minio-4-spinnaker):${MINIO_PORT}
echo $ENDPOINT

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

sudo hal config storage s3 edit --endpoint $ENDPOINT --access-key-id ${MINIO_ROOT_USER} --secret-access-key ${MINIO_ROOT_PASSWORD}
sudo hal config storage edit --type s3
sudo hal config storage s3 edit --path-style-access=true 
sudo hal deploy apply 