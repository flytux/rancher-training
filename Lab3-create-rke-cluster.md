Lab3. create rke cluster from rancher


### From vm02
- k3s-agent-uninstall.sh
- sudo rm -rf /etc/rancher/*

### Login rancher.vm01

- Global > Add Cluster > Create a new > existing nodes
- Cluster Name > Next > check etcd, control plane, worker
- Copy command
- Login vm02
- Paste & Execute command

