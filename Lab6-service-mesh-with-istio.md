### Lab 6. Istio를 이용한 서비스 메쉬 설정

&nbsp;

**1) 랜처에서 Istio 서비스를 설치합니다.**
- Cluster > vm02 > Apps > Istio > Install
- Into the project "System" > Next > Install

&nbsp;

**2) Istio 설정된 워크로드를 배포합니다.**
- Cluster > vm02 > Project/Namespace > Create Project "Observability" 
- Project "Observability" > Create Namespace "istio-books"
- Namespace "istio-books" > ... > Enable Istio Auto Injection
- 우측상단 메뉴 > Import YAML > Copy [istio-books](./config/istio-books.yml)
- 편집창에 붙여넣고 > Default Namespace > istio-books > Import

&nbsp;

**3) Gateway / Virtual Service를 설정합니다.**
- 우측상단 메뉴 > Import YAML Import YAML > Copy [istio-book-gateway](./config/book-gateway.yml)
- Default Namespace > istio-books > Import
- 우측상단 메뉴 > Import YAML Import YAML > Copy [book-virtual-service](./config/book-virtual-service.yml)
- Default Namespace > istio-books > Import

- 웹브라우저에서 배포한 서비스에 접속합니다. http://vm02:31380/productpage
- 해당 서비스는 리뷰페이지의 3가지 버전이 동일한 비율로 보이는 샘플입니다. Ctrl + F5로 새로 고침을 해줍니다.
- Kiali 화면을 통해 서비스 흐름을 확인합니다. : Menu > Istio > Kiali > Graph > Namespace > istio-books
- Display > Traffic Animation, Traffic Distribution 선택
- 샘플 페이지를 Ctrl + F5로 새로 고침을 해주고 Kiali 화면을 확인힙니다.

&nbsp;

**4) Destination Rule / Virtual Services로 유량 제어를 설정합니다.**
- 우측상단 메뉴 > Import YAML > Copy [istio-book-destination-rule](./config/istio-book-destination-rule.yml)
- Default Namespace > istio-books > Import
- 우측상단 메뉴 > Import YAML > Copy [istio-book-virtual-services-traffic-control](./config/istio-book-virtual-service-traffic-control.yml)
- Default Namespace > istio-books > Import

- 웹브라우저에서 배포한 서비스에 접속합니다. http://vm02:31380/productpage
- 새롭게 적용된 서비스 플로우는 리뷰페이지의 2가지 버전이 50:50 비율로 보이는 샘플입니다. Ctrl + F5로 새로 고침을 해줍니다.
- Kiali 화면을 통해 서비스 흐름을 확인합니다. : Menu > Istio > Kiali > Graph > Namespace > istio-books
- Display > Traffic Animation, Traffic Distribution 선택
- 샘플 페이지를 Ctrl + F5로 새로 고침을 해주고 Kiali 화면을 확인힙니다.
