### Lab4. Cluster Operation - Backup / Logging / Monitoring


**0) Install local-path storage class

- local-path storage class를 설치합니다.
- local-path storage 를 기본 스토리지 클래스로 설정합니다.


~~~
k8sadm@vm01: k apply -f charts/local-path/local-path-storage.yaml
~~~

- Cluster local > Storage > StorageClasses > local-path를 찾아 오른쪽 "..." 메뉴를 클릭하여 Set As Default 선택
 

**1) Cluster Backup**

- Rancher에서 클러스터 local을 선택한 후, Apps > Rancher Backups 를 설치합니다.

- Menu > Cluster > local > Apps > Filter "backup" > Rancher Backups
- Install > Install into Project > System > Next
- Default Storage Location > Use Existing Storage Class > local-path, 2Gi > Install

- 설치가 완료된 후 좌측에 Rancher Backups 메뉴가 생성됩니다.

- Backup > Create > Name "init-backup" > 기본 설정으로 "Create" 

**2) Application Logging**

- Cluster > rke > Add Project > Observability
- Select Cluster > rke > Observability Project
- Apps --> Launch --> Search "efk" > Config Pod AntiAffinity Type "soft", Enable Filebit, Enable Metricbit "false"
- Launch
- Connect kibana  : Select App > ekf > /index.html

- Select Cluster rke > Tools > Logging > ElasticSearch
- Endpoint "http://elasticsearch-master.efk:9200" > Test > Save

- Connect kibana
- Create index pattern > rke* > Next step > Time filter @timestamp > Cretae Index Pattern
- Select Discover (Compass Icon)

&nbsp;

**3) Enable monitoring**

- Tools > Monitoring > Enable
- Cluster rke > System > Resources > Workloads

