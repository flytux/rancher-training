1. Install RKE

# from vm01
- git clone https://github.com/flytux/rancher-training
- cd rancher-training
- sudo cp bins/rke /usr/local/bin

# from vm02
- sudo passwd vagrant

# from vm01
- ssh-keygen
- ssh-copy-id vm02

- rke config #all default except below
[+] SSH Address of host (1) [none]: vm02
[+] SSH User of host (vm02) [ubuntu]: vagrant
[+] Is host (vm02) a Control Plane host (y/n)? [y]: y
[+] Is host (vm02) a Worker host (y/n)? [n]: y
[+] Is host (vm02) an etcd host (y/n)? [n]: y

- rke up

- mkdir ~/.kube
- cp kube_config_cluster.yml ~/.kube/config-rke
- export KUBECONFIG=~/.kube/config-rke:$KUBECONFIG

- cat bins/bashrc-k8s >> ~/.bashrc
- source ~/.bashrc

- sed -i 's/default/k3s/g' ~/.kube/config
- sed -i 's/local/rke/g' ~/.kube/config-rke

- sudo cp bins/kubectl /usr/local/bin

- kcg
- kc k3s
- kubectl get pods -A
- kc rke
- kubectl get nodes
- kubectl get ns

