1. Install RKE

- wget https://github.com/rancher/rke/releases/download/v1.3.15/rke_linux-amd64
- chmod 755 rke_linux-amd64 
- mv rke_linux-amd64 /usr/local/bin/rke
- sudo mv rke_linux-amd64 /usr/local/bin/rke

- ssh-keygen
- sudo passwd vagrant

- rke config
[+] Cluster Level SSH Private Key Path [~/.ssh/id_rsa]: 
[+] Number of Hosts [1]: 
[+] SSH Address of host (1) [none]: vm01
[+] SSH Port of host (1) [22]: 
[+] SSH Private Key Path of host (vm01) [none]: 
[-] You have entered empty SSH key path, trying fetch from SSH key parameter
[+] SSH Private Key of host (vm01) [none]: 
[-] You have entered empty SSH key, defaulting to cluster level SSH key: ~/.ssh/id_rsa
[+] SSH User of host (vm01) [ubuntu]: vagrant
[+] Is host (vm01) a Control Plane host (y/n)? [y]: y
[+] Is host (vm01) a Worker host (y/n)? [n]: y
[+] Is host (vm01) an etcd host (y/n)? [n]: y
[+] Override Hostname of host (vm01) [none]: 
[+] Internal IP of host (vm01) [none]: 
[+] Docker socket path on host (vm01) [/var/run/docker.sock]: 
[+] Network Plugin Type (flannel, calico, weave, canal, aci) [canal]: 
[+] Authentication Strategy [x509]: 
[+] Authorization Mode (rbac, none) [rbac]: 
[+] Kubernetes Docker image [rancher/hyperkube:v1.24.4-rancher1]: 
[+] Cluster domain [cluster.local]: 
[+] Service Cluster IP Range [10.43.0.0/16]: 
[+] Enable PodSecurityPolicy [n]: 
[+] Cluster Network CIDR [10.42.0.0/16]: 
[+] Cluster DNS Service IP [10.43.0.10]: 
[+] Add addon manifest URLs or YAML files [no]: 

- rke up

- mkdir ~/.kube
- cp kube_config_cluster.yml ~/.kube/config
- curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
- chmod 755 kubectl && sudo mv kubectl /usr/local/bin

- kubectl get pods
- kubectl get nodes
- kubectl get ns

