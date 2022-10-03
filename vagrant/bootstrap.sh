#!/bin/bash

echo "Add Kernel settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system >/dev/null 2>&1

echo "Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.100.100.101   vm01 rancher.vm01
172.100.100.201   vm02 
EOF

echo "Install docker"
zypper in -y docker git wget zsh 
systemctl enable docker
systemctl start docker

echo "Set root password"
echo -e "1\n1" | passwd root >/dev/null 2>&1
echo "export TERM=xterm" >> /etc/bash.bashrc

echo "Create User and Key"
groupadd -g 2000 k8sadm
useradd -m -u 2000 -g 2000 k8sadm
echo -e "1\n1" | passwd k8sadm >/dev/null 2>&1
echo ' k8sadm ALL=(ALL)   ALL' >> /etc/sudoers

usermod -aG docker k8sadm

#sudo -u k8sadm -H sh -c "ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N \"\";sshpass -p 1 ssh-copy-id k8sadm@vm01;sshpass -p 1 ssh-copy-id k8sadm@vm02"



