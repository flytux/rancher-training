### Lab3. Cluster Operation - Backup / Monitoring


**0) Install App using Helm Chart**

- Add bitnami helm chart repo
- Cluster rke-vm01 > Apps > Repositories > Create
- Name "bitnami" 
- Index URL : https://charts.bitnami.com/bitnami > Create

- Apps > Charts > Filter "apache"
- Select apache > Install > Next > Name "apache" > Next > Install

- Edit YAML : Service Type to NodePort
~~~
  nodePorts:
    http: '30080'
    https: '30443'
  ports:
    http: 80
    https: 443
  sessionAffinity: None
  sessionAffinityConfig: {}
  type: NodePort
~~~

**1) Backup Cluster Resources**

**@vm01**

~~~
$ rke etcd snapshot-save
$ sudo ls -al /opt/rke/etcd-snapshots/
~~~

**@rancher** 
- App > Installed Apps > apache > Delete

**@vm01**

```bash
$ rke etcd snapshot-restore --name rke_etcd_snapshot_2022-10-26T01:23:02Z # except .zip file extension
```

**@rancher**
- Check Workload > apache

**3) Enable monitoring**

- Cluster > Apps > Charts > Filter monitoring
- Select "Monitoring" > Install > Install into Project > System > Next
- Install

- Check Cluster > Monitoring > Grafana
