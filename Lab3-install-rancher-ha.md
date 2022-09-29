Lab3. Install Rancher in cluster HA

- kcg
- kc k3s

- k apply -f charts/cert-manager/cert-manager-v1.8.2.yaml
- k get pods -n cert-manager 

- sudo cp bins/helm /usr/local/bin
- helm install rancher -f charts/rancher/values.yaml ./charts/rancher/ -n cattle-system --create-namespace

- add cluster - existing cluster - put name - create

- copy bottom command, execute curl save to file add.yml
  "curl --insecure -sfL https://rancher.vm01/v3/import/xn25m4hd6mz9tsm9nwr8c57z4w24mwndrvkdxmmdm5gfs4brkpdsln_c-dzvbf.yaml > add.yml"
- vi add.yml # line 109 add
- spec:
    hostAliases:
    - ip: 192.168.121.31
      hostnames:
      - rancher.vm01
- save: wq!

- kcg 
- kc rke
- k apply -f add.yml

- 
