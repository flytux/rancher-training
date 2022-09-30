### Lab4. Cluster Operation - Backup / Logging / Monitoring

&nbsp;

**1) Cluster Backup**

- Apps > Search phpbb > Install
- RKE > Tools > snapshots > Snapshot Now

- Delete Apps > phpbb

- Restore snapshot

&nbsp;

**2) Application Logging**

- Cluster > rke > Add Project > Observability
- Select Cluster > rke > Observability Project
- Apps --> Launch --> Search "efk" > Config Pod AntiAffinity Type "soft", Enable Filebit, Enable Metricbit "false"
- Launch
- Connect kibana  : Select App > ekf > /index.html

- Select Cluster rke > Tools > Logging > ElasticSearch
- Endpoint "http://elasticsearch-master.efk:9200" > Test
- Connect kibana
- Create index pattern > rke*
- Select Discover

&nbsp;

**3) Enable monitoring**

- Tools > Monitoring > Enable


