### Lab 1. Install Rancher Quick-Start

**0. Pre-work**

- Login vm01 and vm02 as root

**@vm01 && @vm02**

- Check and update Your IP Address in ./setup.sh 
```bash
$ ./setup.sh
```

- Login vm01 as k8sadm / 1

**@vm01**

```bash
$ ssh-keygen
$ ssh-copy-id vm01
$ ssh-copy-id vm02
```

- Get Lab Docs & Sources

```bash
$ wget https://github.com/flytux/rancher-training/\
  archive/refs/tags/rev2.zip
$ cd rancher-training-rev2
```

- zsh environment setting
```bash
$ tar xvf charts/code-server/scripts/dev-shell.tgz -C ~
$ zsh
```

- bash environment setting
```bash
$ cat config/bashrc-k8s >> ~/.bashrc
$ source ~/.bashrc
```

**1. Install rancher quick-start**

```bash
$ docker run -d --name rancher --privileged -p 8080:80 -p 8443:443 \ rancher/rancher
$ docker logs  rancher  2>&1 | grep "Bootstrap Password:"
```

- login http://vm01:8080
- change password
- Cluster : local > Copy KubeConfig to Clipboard

```bash
$ mkdir ~/.kube
$ vi ~/.kube/config
# Paste Clipboard & Save Quit
```

**2. Check Cluster**

```bash
$ kubectl get pods -A
$ kubectl get nodes
$ kubectl get cs
$ kubectl cluster-info
```

**3. Deploy workload**

```bash
$ kubectl create deployment nginx --image nginx --port 80
$ kubectl expose deployment nginx
$ kubectl get svc
$ kubectl get pods
$ kubectl exec -it $(kubectl get pods -l app=nginx -o name) -- bash
$ curl -v nginx
```

