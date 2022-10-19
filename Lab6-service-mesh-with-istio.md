### Lab 6. Istio를 이용한 서비스 메쉬 설정

**1) 랜처에서 Istio 서비스를 설치합니다.**
- Cluster > vm02 > Apps > Istio > Install
- Into the project "System" > Next > Install


**2) Deploy Istio Enabled workloads**
- Cluster > rke > Observability > Namespace > Add namespace > Name "istio-books" > Enable istio sidecar auto-injection > Create
- Resources > Workloads > Import YAML > Copy [istio-books](./config/istio-books.yml)
- Paste to Black yaml edit plane > Default Namespace > istio-books > Import

**3) Add Gateway / Virtual Service**
- Resources > Istio > Gateway > Import YAML > Copy [istio-book-gateway](./config/book-gateway.yml)
- Default Namespace > istio-books > Import
- Resources > Istio > Virtual Services >  Import YAML > Copy [book-virtual-service](./config/book-virtual-service.yml)
- Default Namespace > istio-books > Import
- Check Service from web browser http://vm02:31380/productpage
- Reload page 20 times (F5) and check Book Reviews rotates
- Check Kiali service flows : Click Kiali icon > Graph > Namespace > istio-books
- Display > Check Traffic Animation
- Reload page 50 times (F5) and check kiali graph shows

**4) Add Destination Rule / Virtual Services**
- Resources > Istio > Destination Rules > Import YAML > Copy [istio-book-destination-rule](./config/istio-book-destination-rule.yml)
- Default Namespace > istio-books > Import
- Resources > Istio > Virtual Services > Import YAML > Copy [istio-book-virtual-services-traffic-control](./config/istio-book-virtual-service-traffic-control.yml)
- Default Namespace > istio-books > Import
- Check Service from web browser http://vm02:31380/productpage
- Reload page 20 times (F5) and check Book Reviews rotates
- Check Kiali service flows : Click Kiali icon > Graph > Namespace > istio-books
- Reload page 50 times (F5) and check kiali graph shows
