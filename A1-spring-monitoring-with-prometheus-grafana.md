### Lab3. create rke cluster from rancher

&nbsp;

**0) Login Rancher https://rancher.vm01

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

~~~
$ k3s-agent-uninstall.sh # Delete k3s agent node
$ sudo rm -rf /etc/rancher/* 
~~~

- Login vm01

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


- Optional) Add hostAliases to rancher agent
  - Cluster > rke > System > Resources > Workloads > Rancher > View / Edit YAML

    ~~~ 
    # Add below after dnsPolicy line
       hostAliases:
       - hostnames:
         - rancher.vm01
         ip: 172.100.100.101
    ~~~
