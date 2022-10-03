### Lab4. Cluster Operation - Backup / Logging / Monitoring

&nbsp;

**1) Cluster Backup**

- Cluster rke > Default > Apps > Launch > Search phpbb > set phpBB password > Launch
- Login phpbb with service link in App panel (ex. 30888/tcp)
- Cluster rke > Tools > snapshots > Snapshot Now

- Delete Apps > phpbb

- Cluster rke > Tools > snapshots > Restore snapshot
- Cluster rke > Default > Resources > Workloads

&nbsp;

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

