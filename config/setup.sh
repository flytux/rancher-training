#!/bin/sh

echo "=== Update /etc/hosts file ==="
cat >>/etc/hosts<<EOF
10.136.0.3 vm01 rancher.vm01 ldapadmin.vm01 tekton.vm01 argocd.vm01
10.136.0.2 vm02 
EOF

echo "=== Install Docker ==="
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo "=== Create k8sadm user ==="
groupadd -g 2000 k8sadm
useradd -m -u 2000 -g 2000 -s /bin/bash k8sadm
echo -e "1\n1" | passwd k8sadm >/dev/null 2>&1
echo ' k8sadm ALL=(ALL)   ALL' >> /etc/sudoers
usermod -aG docker k8sadm

echo "=== Setup k8s tools ==="
wget https://github.com/rancher/rke/releases/download/v1.3.15/rke_linux-amd64
chmod 755 rke_linux-amd64 && sudo mv rke_linux-amd64 /usr/local/bin/rke

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod 755 kubectl && sudo mv kubectl /usr/local/bin
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
