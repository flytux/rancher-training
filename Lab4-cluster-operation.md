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

$ kubectl create deployment nginx --image nginx --port 80
$ kubectl expose deployment nginx
$ kubectl get svc
$ kubectl get pods
$ kubectl exec -it $(kubectl get pods -l app=nginx -o name) -- bash
$ curl -v nginx

~~~

**2) 클러스터 백업 및 복구

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

