### Lab 6. Enable Service Mesh with Istio

**1) Enable Istio from Rancher**
- Cluster > RKE > Tools > Istio
- Group Access > Select Allow All
- Ingress Gateway > Enable > True > Enable
- Cluster > RKE > System > Check Istio-System namespace workdloads 

**2) Deploy Istio Enabled workloads**
- Cluster > rke > Observability > Namespace > Add namespace > Name "istio-books" > Enable istio sidecar auto-injection > Create
- Resources > Workloads > Import YAML > Copy [istio-books](./config/istio-books.yaml)
