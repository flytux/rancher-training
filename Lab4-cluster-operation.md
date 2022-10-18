### Lab4. Cluster Operation - Backup / Logging / Monitoring


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
~~~

**2) 클러스터 백업 및 복구

- 
~~~
$ kcg # vm02 클러스터 접속 확인
$ k apply -f charts/local-path/local-path-storage.yaml

- Rancher > vm02 > Storage > StorageClasses
- local-path > ... > Set As Default
~~~

- phpbb 샘플 앱을 설치합니다.

~~~
- Apps > Repositories > Create
- Name: "bitnami", URL: https://charts.bitnami.com/bitnami > Create

- Charts > Filter "php" > phpbb 선택 > Install
- Namespace: default > Name: "phpbb" > Install
- 181 라인  type: NodePort로 변경 > Install
- Workload, Storage > PVC, Service 확인
~~~

- 설치 완료 된 후 Services > phpbb 노드 포트 링크 클릭하여 접속 확인

- 클러스터 백업을 수행합니다.

~~~
- Menu > Cluster Management > vm02 > "..." > Take Snapshot
~~~

- 설치한 phpbb를 삭제합니다.

~~~
- Cluster > Apps > Installed Apps > Delete
~~~

- 클러스터 복구를 수행합니다.

~~~
- Menu > Cluster Management > vm02 > "..." > Restore Snapshot
- 최근 스냅샷 선택 > only etcd 선택 > 복구
- Cluster vm02 > Workloas > phpbb 확인
~~~


**2) Application Logging**

- Cluster > rke > Add Project > Observability
- Select Cluster > rke > Observability Project
- Apps --> Launch --> Search "efk" > Config Pod AntiAffinity Type "soft", Enable Filebit, Enable Metricbit "false"
- Launch
- Connect kibana  : Select App > efk > /index.html

- Select Cluster rke > Tools > Logging > ElasticSearch
- Endpoint "http://elasticsearch-master.efk:9200" > Save

- Connect kibana
- Create index pattern > rke* > Next step > Time filter @timestamp > Create Index Pattern
- Select Discover (Compass Icon)

&nbsp;

**3) Enable monitoring**

- Tools > Monitoring > Enable
- Cluster rke > System > Resources > Workloads

