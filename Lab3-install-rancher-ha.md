Lab3. Install Rancher in cluster HA

- cat bins/bashrc-k8s >> ~/.bashrc
- source ~/.bashrc

- k apply -f charts/cert-manager/cert-manager-v1.8.2.yaml

- helm install rancher -f charts/rancher/values.yaml ./charts/rancher/ -n cattle-system --create-namespace
