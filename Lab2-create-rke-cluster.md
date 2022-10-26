**1) Install RKE cluster**

- run rke config

~~~
$ rke config

[+] Cluster Level SSH Private Key Path [~/.ssh/id_rsa]: 
[+] Number of Hosts [1]: 
~~~
**[+] SSH Address of host (1) [none]: vm01**
~~~
[+] SSH Port of host (1) [22]:
[+] SSH Private Key Path of host () [none]: 
[-] You have entered empty SSH key path, trying fetch from SSH key parameter
[+] SSH Private Key of host () [none]: 
[-] You have entered empty SSH key, defaulting to cluster level SSH key: ~/.ssh/id_rsa
~~~
**[+] SSH User of host () [ubuntu]: k8sadm**

**[+] Is host () a Control Plane host (y/n)? [y]: y**

**[+] Is host () a Worker host (y/n)? [n]: y**

**[+] Is host () an etcd host (y/n)? [n]: y**
~~~
[+] Override Hostname of host () [none]: 
~~~
**[+] Internal IP of host () [none]: %YOUR_INTERNAL_IP%**
~~~
[+] Docker socket path on host () [/var/run/docker.sock]: 
[+] Network Plugin Type (flannel, calico, weave, canal, aci) [canal]: 
[+] Authentication Strategy [x509]: 
[+] Authorization Mode (rbac, none) [rbac]: 
[+] Kubernetes Docker image [rancher/hyperkube:v1.20.15-rancher2]: 
[+] Cluster domain [cluster.local]: 
[+] Service Cluster IP Range [10.43.0.0/16]: 
[+] Enable PodSecurityPolicy [n]: 
[+] Cluster Network CIDR [10.42.0.0/16]: 
[+] Cluster DNS Service IP [10.43.0.10]: 
[+] Add addon manifest URLs or YAML files [no]:
~~~
- rke up
- copy config
~~~
$ rke up
$ mkdir -p ~/.kube
$ cp kube_config_cluster.yml ~/.kube/config-rke
$ export KUBECONFIG=$HOME/.kube/config-rke:$HOME/.kube/config
$ k get pods -A
~~~

**2) Import RKE cluster to Rancher**

- login rancher
- Menu > Cluster Management > Import Existing
- Generic > Cluster Name : rke-vm01 > Create
- Copy 2nd Command from registration : bypass certificate verification
- Paste and run at vm01

