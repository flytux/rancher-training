**1) RKE cluster 설치**

- rke 바이너리를 이용하여 클러스터를 설정합니다.

```bash
$ rke config

[+] Cluster Level SSH Private Key Path [~/.ssh/id_rsa]: 
[+] Number of Hosts [1]: 
```

**[+] SSH Address of host (1) [none]: vm01**

```bash
[+] SSH Port of host (1) [22]:
[+] SSH Private Key Path of host () [none]: 
[-] You have entered empty SSH key path, trying fetch from SSH key parameter
[+] SSH Private Key of host () [none]: 
[-] You have entered empty SSH key, defaulting to cluster level SSH key: ~/.ssh/id_rsa
```

**[+] SSH User of host () [ubuntu]: k8sadm**

**[+] Is host () a Control Plane host (y/n)? [y]: y**

**[+] Is host () a Worker host (y/n)? [n]: y**

**[+] Is host () an etcd host (y/n)? [n]: y**

```bash
[+] Override Hostname of host () [none]: 
```

```bash
[+] Internal IP of host () [none]: 
[+] Docker socket path on host () [/var/run/docker.sock]: 
[+] Network Plugin Type (flannel, calico, weave, canal, aci) [canal]: 
[+] Authentication Strategy [x509]: 
[+] Authorization Mode (rbac, none) [rbac]: 
[+] Kubernetes Docker image [rancher/hyperkube:v1.20.15-rancher2]: 
[+] Cluster domain [cluster.local]: 
[+] Service Cluster IP Range [10.43.0.0/16]: 
[+] Enable PodSecurityPolicy [n]: 
[+] Cluster Network CIDR [10.42.0.0/16]: 
[+] Cluster DNS Service IP [10.43.0.10]: 
[+] Add addon manifest URLs or YAML files [no]:
```

- rke 명령어를 이용하여 클러스터를 설치합니다.
- 설치 후 생성된 config 파일을 홈디렉토리/.kube 디렉토리에 복사합니다.
- 클러스터 내 CoreDNS에 "할당받은IP vm01" 값을 설정합니다.

```bash
$ rke up

$ cp kube_config_cluster.yml ~/.kube/config-rke-vm01
$ sed -i 's/local/rke-vm01/g'  ~/.kube/config-rke-vm01
$ export KUBECONFIG=$HOME/.kube/config-rke-vm01:$HOME/.kube/config

$ kcg
$ kc rke-vm01

$ k get pods -A

$ k edit cm coredns -n kube-system

data:
  Corefile: |
    .:53 {
        errors
        health {
          lameduck 5s
        }
        hosts {
          192.0.212.1 vm01 # 할당 받은 내부 IP로 변경합니다.
          fallthrough
        }
- save & quit        
```

**2) Import RKE cluster to Rancher**

- rancher에 로그인 합니다.
- Menu > Cluster Management > Import Existing을 선택합니다.
- Generic > Cluster Name : rke-vm01 > Create를 선택합니다.
- registration 창에서 2번째 명령어 (bypass certificate verification)를 복사합니다.
- vm01의 쉘에서 실행합니다.


**3) Add worker node vm02 to RKE cluster**

- cluster.yml를 수정하여 node vm02를 추가합니다.
- rke 명령어로 클러스터를 재기동 합니다.

```bash
$ vi cluster.yml

nodes:
- address: vm01
  port: "22"
  internal_address: 10.136.0.3
  role:
  - controlplane
  - worker
  - etcd
  hostname_override: ""
  user: k8sadm
  docker_socket: /var/run/docker.sock
  ssh_key: ""
  ssh_key_path: ~/.ssh/id_rsa
  ssh_cert: ""
  ssh_cert_path: ""
  labels: {}
  taints: []
- address: vm02
  port: "22"
  internal_address: 10.136.0.2
  role:
  - worker
  hostname_override: ""
  user: k8sadm
  docker_socket: /var/run/docker.sock
  ssh_key: ""
  ssh_key_path: ~/.ssh/id_rsa
  ssh_cert: ""
  ssh_cert_path: ""
  labels: {}
  taints: []
  
$ rke up
```
