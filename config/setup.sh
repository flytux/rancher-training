#!/bin/sh

echo "Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.0.212.1  vm01 rancher.vm01
192.0.212.2  vm02 ldapadmin.vm02 tekton.vm02 argocd.vm02 grafana.vm02 
EOF

echo "Install Docker"
zypper in -y docker
systemctl enable docker
systemctl start docker

echo "Create k8sadm user"
groupadd -g 2000 k8sadm
useradd -m -u 2000 -g 2000 k8sadm
echo -e "1\n1" | passwd k8sadm >/dev/null 2>&1
echo ' k8sadm ALL=(ALL)   ALL' >> /etc/sudoers
usermod -aG docker k8sadm
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa<<<y
