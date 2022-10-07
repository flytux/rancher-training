### Lab 1. Create K3S Cluster

**0. Pre-work**

- Add host dns names to local
~~~
cat << EOF | sudo tee -a /etc/hosts
192.0.212.1 vm01 rancher.vm01
192.0.212.2 vm02 tekton.vm02 gitea.vm02 argocd.vm02 ldapadmin.vm02 grafana.vm02
EOF
~~~

- Add /etc/hosts on vm01, vm02

**@vm01 && @vm02***
~~~
$ ssh root@vm01


cat << EOF | sudo tee -a /etc/hosts
192.0.212.1 vm01 rancher.vm01
192.0.212.2 vm02 tekton.vm02 gitea.vm02 argocd.vm02 ldapadmin.vm02 grafana.vm02
EOF
~~~

- Clone workshop repo 
- Login vm01 : ssh root@vm01

**@vm01**

~~~
$ sudo zypper in -y docker zsh
$ sudo systemctl enable docker
$ sudo systemctl start docker
$ ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""
$ ssh-copy-id vm01
$ ssh-copy-id vm02

$ git clone https://github.com/flytux/rancher-training

$ cd rancher-training
$ sudo cp bins/* /usr/local/bin
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
$ sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config 
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

