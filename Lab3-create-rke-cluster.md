### Lab3. create rke cluster from rancher

**1) Uninstall k3s**

- Login vm02

~~~
$ k3s-agent-uninstall.sh # Delete k3s agent node
$ sudo rm -rf /etc/rancher/* 
~~~

**2) Install RKE from Rancher**

- Login https://rancher.vm01

- Global > Add Cluster > Create a new > existing nodes
- Cluster Name > Next > check etcd, control plane, worker
- Copy command
- Login vm02
- Paste & Execute command

**) Check cluster status**

- Login vm01

~~~
$ k logs -f $(kubectl get pods -l app=rancher -o name)
~~~
