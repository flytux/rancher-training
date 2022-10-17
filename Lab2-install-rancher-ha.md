### Lab 2. Install Rancher in cluster HA

> Rancher HA installation inside management cluster (Default number of replicas : 3)
> 
> Rancher / Cert-Manager helm charts (Cert-Manager generates and rotates self-signed certificates for rancher)
> 
> Rancher managed information stored in management cluster as CRD kubernetes objects


**1) Check cluster**

**@vm01**

~~~
$ sed -i 's/local/rke-local/g' ~/.kube/config
$ kc rke-local
~~~


**2) Install cert-manager / Rancher with helm**

~~~
$ k apply -f charts/cert-manager/cert-manager-v1.8.2.yaml
$ k rollout status deploy -n cert-manager
$ k get pods -n cert-manager

$ helm install rancher -f charts/rancher/values.yaml ./charts/rancher/ -n cattle-system --create-namespace
$ kn cattle-system
$ k get pods
$ k logs -f $(k get pods -l app=rancher -o name)
~~~


**3) Check Rancher**

- https://rancher.vm01
