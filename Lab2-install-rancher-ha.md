### Lab 2. Install Rancher in Cluster

> Rancher HA 구성은 멀티 노드에 3개 이상의 인스턴스를 구성합니다.
> 
> Rancher / Cert-Manager 를  helm chart를 이용하여 설치합니다. (Cert-Manager 는 클러스터 내 인증서 발급, 갱신 등을 자동화 합니다.)
> 
> Rancher 에 등록된 정보는 클러스터 내 에 쿠버네티스 객체 (커스텀 정의된 객체)로 저장됩니다.


**1) 클러스터 연결 확인**

**@vm01**

~~~
$ sed -i 's/local/vm01/g' ~/.kube/config
$ kc vm01
~~~


**2) Cert-manager / Rancher 설치**

~~~
$ k apply -f charts/cert-manager/cert-manager-v1.8.2.yaml
$ k rollout status deploy -n cert-manager
$ k get pods -n cert-manager

$ helm install rancher -f charts/rancher/values.yaml ./charts/rancher/ -n cattle-system --create-namespace
$ kn cattle-system
$ k get pods
$ k logs -f $(k get pods -l app=rancher -o name)
~~~


**3) Rancher 접속**

- https://rancher.vm01
