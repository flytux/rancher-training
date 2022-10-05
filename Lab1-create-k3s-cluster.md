### Lab 1. Create K3S Cluster

#### 0. Pre-work

**@ local machine**
- copy ssh-key to local .ssh folder
- add VM's public IP to hosts

~~~
$ cat << EOF | sudo tee -a /etc/hosts
GCP_VM01_PublicIP vm01 rancher.vm01
GCP_VM02_PublicIP vm02 tekton.vm02 gitea.vm02 argocd.vm02 ldapadmin.vm02
EOF
~~~~

- Login vm01 & install git
- Start docker daemon 
- Add host names to vm01

~~~
$ ssh k8sadm@vm01
$ sudo zypper install -y git vim

$ sudo systemctl status docker
$ sudo systemctl enable docker
$ sudo systemctl start docker

$ cat << EOF | sudo tee -a /etc/hosts
GCP_VM01_InternalIP vm01 rancher.vm01
GCP_VM02_InternalIP vm02
EOF
~~~

**@ local machine**

- Add host names to vm02
- Start docker daemon 

~~~
$ ssh k8sadm@vm02

$ cat << EOF | sudo tee -a /etc/hosts
GCP_VM01_InternalIP vm01 rancher.vm01
GCP_VM02_InternalIP vm02
EOF

$ sudo systemctl status docker
$ sudo systemctl enable docker
$ sudo systemctl start docker
~~~


**@ vm01**

- Clone workshop repo 
- Config shell environment

~~~
$ git clone https://github.com/flytux/rancher-training

$ cd rancher-training
$ sudo cp bins/* /usr/local/bin

$ tar xvf charts/code-server/scripts/dev-shell.tgz -C ~
$ zsh
~~~

#### 1. Install k3s

~~~
$ curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.10+k3s1 sh -s - --docker --write-kubeconfig-mode 644

$ mkdir ~/.kube
$ sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config && sudo chown k8sadm ~/.kube/config
~~~

#### 2. Check Cluster

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

#### 3. Add worker node

**@ vm02**

- Login vm02

~~~
$ curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.10+k3s1 K3S_URL=https://vm01:6443 K3S_TOKEN=%YOUR K3S CLUSTER TOKEN% sh -
~~~

#### 4. Deploy workload

~~~
$ kubectl create deployment nginx --image nginx --port 80
$ kubectl expose deployment nginx
$ kubectl get svc
$ kubectl get pods
$ kubectl exec -it $(kubectl get pods -l app=nginx -o name) -- bash
$ curl -v nginx
~~~

