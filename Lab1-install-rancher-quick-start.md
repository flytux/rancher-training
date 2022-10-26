### Lab 1. Install Rancher Quick-Start

**0. Pre-work**

- Login vm01 and vm02 as root

**@vm01 && @vm02**

- Check and update Your IP Address in ./setup.sh 
~~~
$ ./setup.sh
~~~

- Login vm01 as k8sadm / 1

**@vm01**

~~~
$ ssh-keygen
$ ssh-copy-id vm01
$ ssh-copy-id vm02
~~~

- Clone workshop repo 

~~~
$ git clone https://github.com/flytux/rancher-training
$ cd rancher-training
~~~

- zsh environment setting
~~~
$ tar xvf charts/code-server/scripts/dev-shell.tgz -C ~
$ zsh
~~~

- bash environment setting
~~~
$ cat config/bashrc-k8s >> ~/.bashrc
$ source ~/.bashrc
~~~

**1. Install rancher quick-start**

~~~
$ docker run -d --name rancher --privileged -p 8080:80 -p 8443:443 rancher/rancher
$ docker logs  rancher  2>&1 | grep "Bootstrap Password:"
~~~

- login http://vm01:8080
- change password
- Cluster : local > Copy KubeConfig to Clipboard

~~~
$ mkdir ~/.kube
$ vi ~/.kube/config
# Paste Clipboard & Save Quit
~~~

**2. Check Cluster**

~~~
# Install kubectl
$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
$ chmod 755 kubectl && sudo mv kubectl /usr/local/bin

$ kubectl get pods -A
$ kubectl get nodes
$ kubectl get cs
$ kubectl cluster-info
~~~

**3. Deploy workload**

~~~
$ kubectl create deployment nginx --image nginx --port 80
$ kubectl expose deployment nginx
$ kubectl get svc
$ kubectl get pods
$ kubectl exec -it $(kubectl get pods -l app=nginx -o name) -- bash
$ curl -v nginx
~~~

