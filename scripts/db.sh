
#!/bin/bash
cat <<EOSTART
#######################################################
#                  spinnaker box setup                #
#######################################################
# DEFAULTS:                                           ~
#%          Install MINIO db                          #
######################################################*

EOSTART

export MINIO_ROOT_USER=minioadmin
export MINIO_ROOT_PASSWORD=minioadmin
export MINIO_PORT="9010"

echo "#######################################################"
echo "start DB"
sudo docker run -it -d --rm -v ~/.minio-data/:/data --name minio-4-spinnaker -p ${MINIO_PORT}:${MINIO_PORT} \
 -e MINIO_ROOT_USER=${MINIO_ROOT_USER} -e  MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD} \
 minio/minio@sha256:69c5be1eb4f7964fa2227b0f2c19126f95a7fb8ea9cfc7cc8c25d8a483aa7748 server /data --address :${MINIO_PORT}
