### Lab 2. Install Rancher in cluster HA

**1) Check cluster**

**@ vm01 **

- vm01에 설치된 클러스터의 이름을 변경합니다.
- 클러스터 이름은 $home/.kube/config 파일에 정의되어 있습니다.
- kc 명령어로 멀티 클러스터 컨텍스트 설정 시 접속 클러스터를 변경할 수 있습니다.

~~~
$ sed -i 's/local/rke/g' ~/.kube/config
$ kc rke
~~~

**2) Install cert-manager / Rancher with helm**

- Rancher 를 설치하기 전에 클러스터 인증서 관리도구인 cert-manager를 설치합니다.
- k rollout status 명령어로 설치 상태를 확인합니다.
- -w (watch) 옵션으로 상태 변화 조회가 가능합니다.

~~~
$ cd ~/rancher-training
$ k apply -f charts/cert-manager/cert-manager-v1.8.2.yaml
$ k rollout status deploy -n cert-manager
$ k get pods -n cert-manager -w 

- helm chart를 이용하여 랜처를 설치합니다.
- kn 명령어를 이용해서 작업 네임스페이스를 고정할 있습니다.
- 파드 상태를 조회하고 rollout 상태를 조회합니다.

$ helm install rancher -f charts/rancher/values.yaml ./charts/rancher/ -n cattle-system --create-namespace
$ kn cattle-system
$ k get pods
$ k rollout status deploy
~~~

**3) Check Rancher**

- 랜처 파드의 로그를 조회합니다.
- 브라우저를 이용해서 랜처 UI에 접속합니다.
- 기본 패스워드는 password 

~~~
$ k logs -f $(kubectl get pods -l app=rancher -o name)
~~~

- https://rancher.vm01
