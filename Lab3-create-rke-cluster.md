### Lab3. create rke cluster from rancher

> RKE Cluster can be installed either from Rancher or RKE binary
> 
> SSH key access / Docker required

&nbsp;

**0) Login Rancher https://rancher.vm01**

&nbsp;

**1) Move Rancher to vm01**
- Cluster > local > System > Resources > Workload > rancher > Edit
- Check Scaling/Upgrade Policy > 'Rolling: start new pods, then stop old'
- Node Scheduling > Run ... on a specific node > vm01 > Save

&nbsp;

**2) Drain node vm02**
- Cluster > local > Nodes > vm02
- ... > Drain

&nbsp;

**3) Uninstall k3s**

- Login vm02

**@vm02**

~~~
$ k3s-agent-uninstall.sh # Delete k3s agent node
$ sudo rm -rf /etc/rancher/* 
~~~

- Login vm01

**@vm01**

~~~
$ kubectl get nodes
$ kubectl delete node vm02
~~~


&nbsp;

**4) Install RKE from Rancher**

- Login https://rancher.vm01

- Global > Add Cluster > Create a new > existing nodes
- Cluster Name "rke" > Next > check etcd, control plane, worker
- Copy command
- Login vm02
- Paste & Execute command

&nbsp;

**5) Check cluster status**

- Login vm01

~~~
$ k logs -f $(kubectl get pods -l app=rancher -o name)
~~~

&nbsp;

**6) Check workloads**
- Cluster > rke > System > Resources > Workloads


- Add hostAliases to rancher agent via YAML
  - Cluster > rke > System > Resources > Workloads > cattle-cluster-agent > View / Edit YAML

    ~~~ 
    # Add below after dnsPolicy line 263

       dnsPolicy: ClusterFirst
       hostAliases:
       - hostnames:
         - rancher.vm01
         ip: 192.0.212.1 # Your VM01 IP Address
    ~~~

- Add host aliases via rancher UI
- cattle-cluster-ageent > Edit > Networking > Host Aliases > IP Address > 192.0.212.1X > Hostname > rancher.vm01 > Save

---
**Option 4-1) Install RKE from rke binary**

1) Pre-install

~~~
$ su - k8sadm
$ ssh-keygen
- without passphrase

$ ssh-copy-id localhost
- enter password : 1

$ sh localhost # test login
$ docker ps # test docker command
~~~

2) RKE install

Select default vale - enter - **Except SSH Address, User, Control Plance, Worker, Etcd Role**

~~~
$ rke config

[+] Cluster Level SSH Private Key Path [~/.ssh/id_rsa]: 
[+] Number of Hosts [1]: 
~~~
**[+] SSH Address of host (1) [none]: vm02**
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
[+] Internal IP of host () [none]: 
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
- copy config
~~~
$ mkdir -p ~/.kube
$ cp kube_config_cluster.yml ~/.kube/config
$ k get pods -A
~~~
