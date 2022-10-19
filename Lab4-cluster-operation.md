### Lab4. Cluster Operation - Backup / Monitoring

&nbsp;

**1) 멀티 클러스터 컨텍스트 설정**

- 여러 개의 KUBECONFIG 파일을 환경변수에 설정하여 멀티 클러스터에 설정을 합니다.- 
- Rancher UI 로그인 > Cluster "vm02" 선택
- 우측 상단 "Copy Kubeconfig ..." 클릭하여 설정 복사
- k8sadm@vm01 로그인
~~~
$ vi ~/.kube/config-vm02
~~~
- 붙여 넣기 후 저장
~~~
$ export KUBECONFIG=$HOME/.kube/config:$HOME/.kube/config-vm02

$ kcg
$ kc local
$ k get pods -A
$ kc vm02
$ k get pods -A

$ kubectl create deployment nginx --image nginx --port 80
$ kubectl expose deployment nginx
$ kubectl get svc
$ kubectl get pods
$ kubectl exec -it $(kubectl get pods -l app=nginx -o name) -- bash
$ curl -v nginx

~~~
&nbsp;

**2) 클러스터 백업 및 복구**

- 클러스터 백업을 수행합니다.

~~~
- Menu > Cluster Management > vm02 > "..." > Take Snapshot
~~~

- 설치한 nginx를 삭제합니다.

~~~
- Cluster > Workloads > nginx > Delete
~~~

- 클러스터 복구를 수행합니다.

~~~
- Menu > Cluster Management > vm02 > "..." > Restore Snapshot
- 최근 스냅샷 선택 > only etcd 선택 > 복구
- Cluster vm02 > Workloas > nginx 확인
~~~

&nbsp;

**2-1) 랜처를 통해 설치한 클러스터가 아닌 경우 (RKE imported)**

- RKE 클러스터는 rke 명령어를 이용하여 ETCD 스냅삿 백업 / 복구가 가능합니다.
- RKE 클러스터 설치 시 생성된 cluster.yml, cluster.rkestate 화일이 있는 폴더에서 실행합니다.

~~~
$ rke etcd snapshot-save 

INFO[0007] Finished saving/uploading snapshot [rke_etcd_snapshot_2022-10-19T01:41:16Z] on all etcd hosts
~~~

- 정상 종료 시 위와 같은 메시지가 출력됩니다.
- 백업 파일은 마스터 노드 vm의 /opt/rke/etcd-snapshots 폴더에 %스냅샷이름%.zip 파일 명으로 저장됩니다.
- ex) rke_etcd_snapshot_2022-10-19T01:41:16Z.zip

- rke etcd snapshot-restore %스냅샷이름% 로 해당 백업본을 복구합니다.

~~~
$ rke etcd snapshot-restore --name rke_etcd_snapshot_2022-10-19T01:41:16Z

INFO[0082] Finished restoring snapshot [rke_etcd_snapshot_2022-10-19T01:41:16Z] on all etcd hosts
~~~
- etcd snapshot 복구 시에는 클러스터 서비스가 순차적으로 재기동 되므로 일시적인 클러스터 서비스 중단이 필요합니다.

&nbsp;

**3) 클러스터 모니터링 설치**

- 랜처에서 클러스터 모니터링 앱을 이용하여 프로메테우스 / 그라파나 모니터링 환경을 설치합니다.
- Cluster > vm02 > Apps > Monitoring > Install > Install into project "System" > Next > Install
- Cluster > vm02 > Monitoring > 메뉴를 통해서 그라파나와 프로메네우스 접속이 가능합니다.


