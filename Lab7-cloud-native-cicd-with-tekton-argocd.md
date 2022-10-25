### Lab 7. Cloud Native CI/CD with Tekton and ArgoCD

> Tekton을 이용하여 Build 파이프라인을 구성합니다.
> 
> Tekton은 가볍고 쿠버네티스와 완벽하게 호환되며, 어느 클러스터나 쉽게 구성이 가능합니다.
> 쿠버네티스 CRD로 구성되어 쿠버네티스의 장점을 모두 이용할 수 있고,
> Tekton Hub를 통해  검증된 Task를 이용할 수 있습니다. [Tekton Hub](https://hub.tekton.dev/)

&nbsp;

**0) Gitea, Docker Registry 설치**

- k8sadm@vm01로 로그인하여 vm02 클러스터로 설정합니다.

**@vm01**

~~~
$ kc vm02
$ kcg

$ k apply -f charts/gitea/deploy-gitea.yml
~~~

- 웹브라우저로 설정 화면을 접속합니다 : http://gitea.vm02
- Gitea Base URL : http://gitea.gitea:3000 로 설정하고 설치합니다.
- 웹 브라우저로 재 접속하여,
- User를 등록합니다 > ID: tekton, Password: 12345678
- 소스 레파지토리를 복제합니다. New migration > Git > https://github.com/flytux/kw-mvn.git
- 배포 레파지토리를 복제합니다. New migration > Git > https://github.com/flytux/kw-mvn-deploy.git

- 클러스터 DNS 서버에 vm02 호스트 주소를 등록하고,
- 도커 레지스트리를 설치합니다.

~~~
$ # coredns에 클러스터에서 참조할 dns를 추가합니다.
$ k edit cm coredns -n kube-system
$ # Add below
    health {
          lameduck 5s
    }
    
     hosts {
        192.0.212.2 vm02 # Update YOUR vm02 IP
        fallthrough
     }

$ helm install docker-registry -f charts/docker-registry/values.yaml charts/docker-registry -n registry --create-namespace
$ curl -v vm02:30005/v2/_catalog

~~~

**@vm02**

- vm02 호스트의 도커 데몬에 tls 비활성화 설정을 적용하고, 도커 데몬을 재기동 합니다.
- vm02 클러스터가 도커 데몬에서 구동되므로, 재기동 시까지 시간이 잠시 소요됩니다.
- 도커 레지스트리에 접속 테스트를 수행합니다.

~~~
$ sudo vi /etc/docker/daemon.json
# replace below and save
{ 
  "insecure-registries": ["vm02:30005"]
}

$ sudo systemctl restart docker

$ sudo docker login vm02:30005
# ID / Password > tekton / 1 
~~~

- 랜처에서 "DEVOPS" 프로젝트를 생성합니다.

&nbsp;

**1) Tekton Pipelines, Dashboard, Triggers 설치**

**k8sadm@vm01**

~~~
$ kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.29.1/release.yaml
$ k apply -f charts/tekton/tekton-dashboard-release.yaml
$ kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/previous/v0.17.1/release.yaml
$ kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/previous/v0.17.1/interceptors.yaml
~~~

- http://tekton.vm02

- http://rancher.vm01

- 네임스페이스 gitea, registry, tekton-pipelines 를 "DEVOPS" project로 이동합니다.

&nbsp;

**2) 빌드 파이프라인 어플리케이션 빌드를 위한 태스크와 파이프라인을 설치합니다.**

~~~
$ k create ns build
$ kn build
$ k apply -f charts/tekton/pipeline
$ tkn t ls
$ tkn p ls
~~~

- 랜처에서 "APPS" 프로젝트를 추가합니다.
- 네임스페이스 build를 "APPS" 프로젝트로 이동합니다.

&nbsp;

**3) ArgoCD를 helm chart를 이용하여 설치합니다. **
~~~
$ kubectl create namespace argocd
$ kubectl apply -n argocd -f charts/argocd/

#  관리자 초기 패스워드 확인
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
~~~

&nbsp;

**4) ArgoCD 로그인 및 Argo App 생성**

- Cluster vm02 > Namespaces > argocd > DEVOPS Project로 이동
- Cluster vm02 > Workloads > Only System Namespaces > Filter "nginx" > nginx-ingress-controller > ... > Edit 
- Command > Arguments > "--enable-ssl-passthrough"를 마지막에 추가 후 저장
- nginx 컨트롤러가 재기동 되어야 ingress를 통한 접속이 가능합니다.

- 웹 브라우저에서 ArgoCD 접속 : https://argocd.vm02
- ID : admin
- Password : 앞에서 확인한 관리자 패스워드

- ArgoCD App 생성

**@vm01**

~~~
$ k apply -f charts/tekton/argo-app-kw-mvn.yml
~~~

&nbsp;

**5) 파이프라인에서 사용할 argocd-token 생성**
- Cluster vm02 > Storage > ConfigMap > argocd-cm > Edit 
- data에 아래 키/밸류 추가 
  Key: accounts.admin Value: apiKey, login
- Save

- ArgoCD 로그인 : https://argocd.vm02
- Manage > Account > admin > Tokens > Generate New 로 어플리케이션 토큰 생성
- Token 복사

- vm01 로그인

- $ vi charts/tekton/argo-token.sh 
- ARGOCD_AUTH_TOKEN 값을 생성한 토큰으로 변경 후 저장
- $ charts/tekton/argo-token.sh 로 시크릿 생성


&nbsp;

**6) Pipeline 실행**
~~~
$ kcg
$ kc vm02
$ kn build
$ k create -f charts/tekton/pipeline/pr-kw-build.yml
$ tkn pr logs -f 
~~~
- Tekton 대시보드 접속
- http://tekton.vm02/#/namespaces/build/pipelineruns

&nbsp;

- 배포된 어플리케이션 접속
- Check application : http://vm02:30088/ 
  
**7) Gitea Repo에 웹훅 추가**

- http://gitea.vm02/tekton/kw-mvn

- Settings > Webhooks > Add Webhook > Gitea
- Target URL : http://el-build-listener.build:8080
- Add Webhook
- Webhook > Test Delivery 선택
- Pipeline Runs 구동 상태 확인

&nbsp;

**8) Git 레파지토리에 소스 push 후 파이프라인 자동 기동 확인**
- Edit source and commit
- Pipeline 구동 확인
- ArgoCD에서 앱 배포 상태 확인
- 어플리케이션 접속 후 배 : http://vm02:30088/ 

&nbsp;

