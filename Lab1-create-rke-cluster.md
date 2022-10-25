### Lab 1. Create RKE Cluster

#### 0. Pre-work

**@ local machine**
- hosts 파일에 vm01 / vm02 IP와 도메인 이름을 추가합니다.
- 예) 윈도우즈의 경우 관리자 권한으로 C:/windows/System32/etc/drivers/hosts 파일 편집

~~~
할당된VM01-IP vm01 rancher.vm01
할당된VM02-IP vm02 ldapadmin.vm02 tekton.vm02, argocd.vm02
~~~

- vm01 에 k8sadm 사용자로 접속합니다.(ssh k8sadm@vm01)
- k8sadm ssh key를 vm01, vm02에 등록합니다. (ssh-copy-id, 패스워드 입력)
- 트레이닝 레파지토리를 클론하고, 필요한 실행파일을 vm01 /usr/local/bin에 복사합니다.
- kubectl 사용을 지원하기 위한 쉘 환경을 설정합니다. (zsh)


~~~
$ ssh k8adm@vm01
$ ssh-copy-id k8sadm@vm01
$ ssh-copy-id k8sadm@vm02

$ ssh vm01
$ ssh vm02

$ git clone https://github.com/flytux/rancher-training

$ cd rancher-training
$ sudo cp bins/* /usr/local/bin

$ tar xvf charts/code-server/scripts/dev-shell.tgz -C ~
$ zsh
~~~

#### 1. Install RKE Cluster

- rke config -n config/cluster.yml 실행하여 클러스터 설정파일을 생성합니다.

- 설정 값 입력 시 아래를 제외한 나머지는 기본값을 (엔터) 을 적용합니다.
- 호스트 주소, :  vm01,  사용자 : k8sadm, 클러스터 역할 : control plane, worker, etcd

- [+] SSH Address of host (1) [none]: **vm01**
- [+] SSH User of host (vm01) [ubuntu]: **k8sadm**
- [+] Is host (vm01) a Control Plane host (y/n)? [y]: **y**
- [+] Is host (vm01) a Worker host (y/n)? [n]: **y**
- [+] Is host (vm01) an etcd host (y/n)? [n]: **y**


~~~
$ k8sadm@vm01:~/rancher-training> rke config -n config/cluster.yml
[+] Cluster Level SSH Private Key Path [~/.ssh/id_rsa]: 
[+] Number of Hosts [1]: 
[+] SSH Address of host (1) [none]: vm01
[+] SSH Port of host (1) [22]: 
[+] SSH Private Key Path of host (vm01) [none]: 
[-] You have entered empty SSH key path, trying fetch from SSH key parameter
[+] SSH Private Key of host (vm01) [none]: 
[-] You have entered empty SSH key, defaulting to cluster level SSH key: ~/.ssh/id_rsa
[+] SSH User of host (vm01) [ubuntu]: k8sadm
[+] Is host (vm01) a Control Plane host (y/n)? [y]: y
[+] Is host (vm01) a Worker host (y/n)? [n]: y
[+] Is host (vm01) an etcd host (y/n)? [n]: y
[+] Override Hostname of host (vm01) [none]: 
[+] Internal IP of host (vm01) [none]: 
[+] Docker socket path on host (vm01) [/var/run/docker.sock]: 
[+] Network Plugin Type (flannel, calico, weave, canal, aci) [canal]: 
[+] Authentication Strategy [x509]: 
[+] Authorization Mode (rbac, none) [rbac]: 
[+] Kubernetes Docker image [rancher/hyperkube:v1.24.4-rancher1]: 
[+] Cluster domain [cluster.local]: 
[+] Service Cluster IP Range [10.43.0.0/16]: 
[+] Enable PodSecurityPolicy [n]: 
[+] Cluster Network CIDR [10.42.0.0/16]: 
[+] Cluster DNS Service IP [10.43.0.10]: 
[+] Add addon manifest URLs or YAML files [no]:
~~~

- rke up --config config/cluster.yml 로 클러스터를 생성합니다.
- 네트워크 상태 등에 따라 3~5분 정도 소요됩니다.

~~~
$ k8sadm@vm01:~/rancher-training> rke up --config config/cluster.yml 
~~~

- INFO[0152] Finished building Kubernetes cluster successfully 와 같이 출력 후 종료되면 정상입니다.
- 종료 후 생성된 클러스터 접속을 위한 config 파일 디렉토리를 생성하고 config 파일을 복사합니다.

~~~
$ mkdir ~/.kube
$ cp config/kube_config_cluster.yml ~/.kube/config
~~~

#### 2. Check Cluster

- 클러스터 상태를 확인합니다.
- 클러스터 내 전체 네임스페이스의 파드를 조회합니다.
- 클러스터 노드를 조회합니다.
- 클러스터 마스터 노드 상태를 조회합니다.
- 클러스터 정보를 조회합니다.

~~~
$ kubectl get pods -A
$ kubectl get nodes
$ kubectl get cs
$ kubectl cluster-info
~~~

#### 3. Deploy workload

**@ vm01**

- zsh 환경에서는 k, kcg, kc, kn 등의 alias가 설정되어 있습니다.
- zsh 환경에서 nginx 워크로드를 배포하고, 구동 상태를 확인합니다.

~~~
$ zsh
$ k create deployment nginx --image nginx --port 80
$ k expose deployment nginx
$ k get svc
$ k get pods
$ k exec -it $(kubectl get pods -l app=nginx -o name) -- bash
$ curl -v nginx
~~~

- bash 를 선호하는 경우 아래 명령어를 실행합니다.

~~~
$ cat <<EOF >> ~/.bashrc
# k8s alias

source <(kubectl completion bash)
complete -o default -F __start_kubectl k

alias k=kubectl
alias vi=vim
alias kn='kubectl config set-context --current --namespace'
alias kc='kubectl config use-context'
alias kcg='kubectl config get-contexts'
alias di='docker images --format "table {{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.Size}}\t{{.CreatedSince}}"'
EOF

$ source ~/.bashrc
~~~

