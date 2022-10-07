### Lab 1. Create K3S Cluster

**0. Pre-work**

- Add host dns names to local
~~~
%VM01_EXTERNAL_IP% vm01 rancher.vm01
%VM02_EXTERNAL_IP% vm02 ldapamdin.vm02 gitea.vm02 tekton.vm02, argocd.vm02 grafana.vm02
~~~

- Add /etc/hosts on vm01, vm02

~~~
%VM01_INTERNAL_IP% vm01 rancher.vm01
%VM02_INTERNAL_IP% vm02 
~~~

- Clone workshop repo 
- Login vm01 : ssh k8sadm@vm01

**@vm01**

~~~
$ sudo zypper in -y git
$ git clone https://github.com/flytux/rancher-training

$ cd rancher-training
$ sudo cp bins/* /usr/local/bin

$ sudo systemctl status docker
$ sudo systemctl enable docker
$ sudo systemctl start docker
~~~

- zsh environment setting
~~~
$ tar xvf charts/code-server/scripts/dev-shell.tgz -C ~
$ zsh
~~~


**1. Install k3s**

~~~
$ curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.10+k3s1 sh -s - --docker --write-kubeconfig-mode 644

$ mkdir ~/.kube
$ sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config && sudo chown k8sadm ~/.kube/config
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
$ sudo cat /var/lib/rancher/k3s/server/node-token
~~~

**3. Add worker node**

- Login vm02

**@vm02**

~~~
$ sudo systemctl enable docker
$ sudo systemctl start docker

$ curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.10+k3s1 K3S_URL=https://vm01:6443 K3S_TOKEN=%YOUR K3S CLUSTER TOKEN% sh -s - --docker
~~~

**4. Deploy workload**

- Login vm01

**@vm01**

~~~
$ kubectl create deployment nginx --image nginx --port 80
$ kubectl expose deployment nginx
$ kubectl get svc
$ kubectl get pods
$ kubectl exec -it $(kubectl get pods -l app=nginx -o name) -- bash
$ curl -v nginx
~~~

