### Lab3. create rke cluster from rancher

> RKE Cluster 는 랜처 UI 및 RKE cli 를 이용하여 설치합니다.
> 
> SSH 키 등록과 도커 런타임이 설치되어야 합니다.


**1) Rancher 접속 https://rancher.vm01**

- Rancher 홈 > Cluster > Create
- Use exisiting node .. > Custom 
- Cluster Name > "vm02" > Next
- etcd, control plane, worker 선택
- 아래 생성된 스크립트 복사

**2) Rancher 설치 명령 실행

- k8sadm 사용자로 vm02 로그인 : k8sadm@vm02
- 복사한 스크립트 실행
- Cluster Manager > vm02 > Provisioning Log 로 진행상태 조회

