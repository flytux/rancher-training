### Lab3. create rke cluster from rancher

**1) Drain node vm02**

- Apply PodDisruptioPolicy
- Import YAML to cattle-system namespace
~~~
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: rancher
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: rancher
~~~

- Cluster > local > Nodes > vm02
- ... > Drain


**2) Uninstall k3s**

- Login vm02

~~~
$ k3s-agent-uninstall.sh # Delete k3s agent node
$ sudo rm -rf /etc/rancher/* 
~~~

**3) Install RKE from Rancher**

- Login https://rancher.vm01

- Global > Add Cluster > Create a new > existing nodes
- Cluster Name > Next > check etcd, control plane, worker
- Copy command
- Login vm02
- Paste & Execute command

**4) Check cluster status**

- Login vm01

~~~
$ k logs -f $(kubectl get pods -l app=rancher -o name)
~~~

**5) Check workloads**

- Edit cattle-cluster-agent YAML
- add hostaliases rancher.vm01

~~~
     dnsPolicy: ClusterFirst # After dnsPolicy 
     hostAliases:
      - hostnames:
        - rancher.vm01
        ip: 10.128.0.54
~~~
