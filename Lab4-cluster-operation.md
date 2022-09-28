Lab4. Cluster Operation

- k apply -f charts/local-path/local-path-storage.yaml
- Storage --> StorageClasses --> local-path --> ... --> Reset Default

- https://rancher.vm01/dashboard/c/local/explorer/tools
- Rancher Backups --> Install
- Install into Project --> System --> Next
- Use an existing storage class --> local-path / 2Gi --> Install

- Rancher Backups --> Create --> Name --> Create
- Rancher Backups --> Restores --> Target Backup --> Backup Filename --> Create

- Apps --> Monitoring --> Default Values --> Install
- Monitoring --> Grafana --> Prometheus Targets


