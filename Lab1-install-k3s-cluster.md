### Lab 1. Install K3S Cluster

**0. Pre-work**

- Add /etc/hosts on vm01, vm02
~~~
172.100.100.101 vm01 rancher.vm01
172.100.100.201 vm02
~~~

- Clone workshop repo 
- Login vm01

~~~
$ git clone https://github.com/flytux/rancher-training

$ cd rancher-training
$ sudo cp bins/* /usr/local/bin

$ cat config/bashrc-k8s >> ~/.bashrc
$ source ~/.bashrc
~~~

**1. Install k3s**

~~~
$ curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.10+k3s1 sh -s - --docker --write-kubeconfig-mode 644

$ mkdir ~/.kube
$ sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config && sudo chown vagrant:vagrant ~/.kube/config
$ export KUBECONFIG=$HOME/.kube/config
~~~

**2. Check Cluster**

~~~
$ kubectl get pods -A
$ kubectl get nodes
$ kubectl get cs
$ kubectl cluster-info
~~~

- Type cluster-token

~~~
sudo cat /var/lib/rancher/k3s/server/node-token
~~~

**3. Add worker node**

- Login vm02

~~~
$ curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.10+k3s1 K3S_URL=https://vm01:6443 K3S_TOKEN=K1064cad4981b768acbbb792cc49e7c547809dd646aa7098a009c0709cb328d4ba8::server:056e84d47a71d7b2068902216856c7f8 sh -
~~~

**4. Deploy workload**

~~~
$ kubectl create deployment nginx --image nginx --port 80
$ kubectl expose deployment nginx
$ kubectl get svc
$ kubectl get pods
$ kubectl exec -it $(kubectl get pods -l app=nginx -o name) -- bash
$ curl -v nginx
~~~

