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
- add dns entry to coredns "YOUR_INTERNAL_IP vm01"

~~~
$ rke up

$ cp kube_config_cluster.yml ~/.kube/config-rke-vm01
$ sed -i 's/local/rke-vm01/g'  ~/.kube/config-rke-vm01
$ export KUBECONFIG=$HOME/.kube/config-rke-vm01:$HOME/.kube/config

$ kcg
$ kc rke-vm01

$ k get pods -A

$ k edit cm coredns -n kube-system

data:
  Corefile: |
    .:53 {
        errors
        health {
          lameduck 5s
        }
        hosts {
          10.136.0.3 vm01 # REPLACE WITH YOUR INTERNAL IP
          fallthrough
        }
- save & quit        
~~~

**2) Import RKE cluster to Rancher**

- login rancher
- Menu > Cluster Management > Import Existing
- Generic > Cluster Name : rke-vm01 > Create
- Copy 2nd Command from registration : bypass certificate verification
- Paste and run at vm01

