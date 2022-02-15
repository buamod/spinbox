
#!/bin/bash
cat <<EOSTART
#######################################################
#                  spinnaker box setup                #
#######################################################
#%          Configure storage                         ^ 
######################################################*

EOSTART

echo "#######################################################"
echo "configure halyard storage k3s"

ENDPOINT=http://$(sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' minio-4-spinnaker):${MINIO_PORT}
echo $ENDPOINT

sudo hal config storage s3 edit --endpoint $ENDPOINT --access-key-id ${MINIO_ROOT_USER} --secret-access-key ${MINIO_ROOT_PASSWORD}
sudo hal config storage edit --type s3
sudo hal config storage s3 edit --path-style-access=true 
