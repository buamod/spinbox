
#!/bin/bash
cat <<EOSTART
#######################################################
#                  spinnaker box setup                #
#######################################################
# DEFAULTS:                                           ~
#%          Install k3s                            !
######################################################*

EOSTART

echo "#######################################################"
echo "install k3s"
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.9+k3s1 K3S_KUBECONFIG_MODE="644" sh -