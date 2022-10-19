### A1 Spring Monitoring with Prometheus Service Monitor and Grafana

&nbsp;

**1) 프로메테우스 Service Monitor 추가**
~~~
$ k apply -f config/spring-monitor.yml
~~~

- 서비스 모니터를 추가하면 프로메테우스 오퍼레이터가 자동으로 모니터링 타겟을 추가합니다.
- Cluster > vm02 > Monitoring > Prometheus Targes 
- "serviceMonitor/cattle-monitoring-system/spring-boot-actuator-monitor/0 (1/1 up)" 확인

&nbsp;

**2) Add Grafana Dashboard**

- Cluster > vm02 > Monitoring > Grafana
- Login admin / prom-operator
- Import > Import via panel json
- Copy and Paste config/spring-monitor.json

&nbsp;

**3) Check Dashboard**
