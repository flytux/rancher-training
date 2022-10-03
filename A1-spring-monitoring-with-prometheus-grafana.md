### A1 Spring Monitoring with Prometheus Service Monitor and Grafana

&nbsp;

**1) Add Service Monitor**
~~~
$ k apply -f config/spring-monitor.yml
~~~

- https://rancher.vm01/k8s/clusters/c-4xpcm/api/v1/namespaces/cattle-prometheus/services/http:access-prometheus:80/proxy/

&nbsp;

**2) Add Grafana Dashboard**

- https://rancher.vm01/k8s/clusters/c-4xpcm/api/v1/namespaces/cattle-prometheus/services/http:access-grafana:80/proxy/

- Login admin / admin
- Import > Import via panel json
- Copy and Paste config/spring-monitor.json

&nbsp;

**3) Check Dashboard**
