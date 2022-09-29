### Lab4. Cluster Operation

**1) Cluster Backup**

- RKE > Tools > snapshots > Snapshot Now
- Deploy nginx 
- Restore snapshot

**2) Application Logging**

- Create Project "Observability"

- Apps --> Launch --> Config Pod AntiAffinity Type "soft"
- Install Logging
- Connect kibana

- Select Cluster rke > Tools > Logging > ElasticSearch
- Endpoint "http://elasticsearch-master.efk:9200" > Test
- Connect kibana
- Create index pattern > rke*

**3) Enable monitoring**

- Tools > Monitoring > Enable


