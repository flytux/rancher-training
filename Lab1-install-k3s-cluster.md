Lab 1: Install K3S Cluster

1. Install k3s 

- curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.10+k3s1 sh -s - --docker --write-kubeconfig-mode 644

- mkdir ~/.kube
- sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
- export KUBECONFIG=$HOME/.kube/config

- kubectl get pods -A
- kubectl get nodes
- kubectl get cs
- kubectl cluster-info

2. Deploy workload

- kubectl create deployment nginx --image nginx --port 80
- kubectl expose deployment nginx
- kubectl get svc
- kubectl get pods
- kubectl exec -it $(kubectl get pods -l app=nginx -o name) -- bash
- curl -v nginx

