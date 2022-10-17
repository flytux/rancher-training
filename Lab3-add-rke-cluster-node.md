### Lab3. Add RKE Cluster Node

**1) Edit cluster.yml**

- k8sadm 계정의 ssh-key를 vm02에 추가합니다.

~~~
$ k8sadm@vm01: ssh-copy-id vm02
~~~

- cluster.yml 파일을 수정하여 node 리스트에 vm02를 추가합니다.
- address, user, internal_address를 vm02에 맞게 수정합니다.
- role: 에 worker 만 추가합니다.

~~~
nodes:
- address: vm01
  port: "22"
  internal_address: 10.128.15.201
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
  internal_address: 10.128.15.202
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
~~~

- 저장하고 rke up을 실행합니다.
- rke up을 실행하는 vm01에서 ssh vm02로 접속이 가능하여야 합니다.

~~~
$ rke up
~~~

- 새로운 노드 vm02가 클러스터에 추가되었습니다.
- k get nodes 명령어로 노드 상태를 확인합니다.
- rancher UI를 통해서도 확인할 수 있습니다.

~~~
$ k get nodes
~~~
