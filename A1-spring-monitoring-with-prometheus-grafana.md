### A1 Spring Monitoring with Prometheus Service Monitor and Grafana

&nbsp;

**1) Add Service Monitor**
~~~
$ k apply -f config/spring-monitor.yml
~~~

- Cluster > rke > Project > APPS > Resources > Istio > Prometheus Link
- Status > Targets

&nbsp;

**2) Add Grafana Dashboard**

- https://rancher.vm01/k8s/clusters/c-4xpcm/api/v1/namespaces/cattle-prometheus/services/http:access-grafana:80/proxy/

- Cluster > rke > Cluster-Metrics > Grafana Link
- Login admin / admin
- Import > Import via panel json
- Copy and Paste config/spring-monitor.json

&nbsp;

**3) Check Dashboard**
