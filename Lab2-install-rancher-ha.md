### Lab 2. Install Rancher in cluster HA

**1) Check cluster**

~~~
$ sed -i 's/default/k3s/g' ~/.kube/config
$ kc k3s
$ cd ~/rancher-training
~~~

**2) Install cert-manager / Rancher with helm**

~~~
$ k apply -f charts/cert-manager/cert-manager-v1.8.2.yaml
$ k get pods -n cert-manager
$ k get pods -n cert-manager -w

$ helm install rancher -f charts/rancher/values.yaml ./charts/rancher/ -n cattle-system --create-namespace
$ kn cattle-system
$ k get pods
~~~

**3) Check Rancher**

~~~
$ k logs -f $(kubectl get pods -l app=rancher -o name)
~~~
- https://rancher.vm01
