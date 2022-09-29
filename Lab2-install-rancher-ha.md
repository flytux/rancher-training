### Lab3. Install Rancher in cluster HA

**1) Check cluster**
- kcg
- kc k3s

**2) Install cert-manager / Rancher with helm**
`k apply -f charts/cert-manager/cert-manager-v1.8.2.yaml`
`k get pods -n cert-manager` 

`sudo cp bins/helm /usr/local/bin`
`helm install rancher -f charts/rancher/values.yaml ./charts/rancher/ -n cattle-system --create-namespace`
