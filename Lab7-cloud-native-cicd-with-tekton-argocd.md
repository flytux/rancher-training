### Lab 7. Cloud Native CI/CD with tekton and argocd

> Tekton을 이용하여 Build 파이프라인을 구성합니다.
> 
> Tekton은 가볍고 쿠버네티스와 완벽하게 호환되며, 어느 클러스터나 쉽게 구성이 가능합니다.
> 쿠버네티스 CRD로 구성되어 쿠버네티스의 장점을 모두 이용할 수 있고,
> Tekton Hub를 통해 다양한 Task를 이용할 수 있습니다. [Tekton Hub](https://hub.tekton.dev/)

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
$ # Add in cluster dns name to coredns
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

**2) Install Pipeline**

~~~
$ k create ns build
$ kn build
$ k apply -f charts/tekton/pipeline
$ tkn t ls
$ tkn p ls
~~~
- Add Project "APPS" in Rancher
- Move build namespace to "APPS" project

&nbsp;

**3) Install ArgoCD**
~~~
$ kubectl create namespace argocd
$ kubectl apply -n argocd -f charts/argocd/
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d # Get admin password
~~~

&nbsp;

**4) ArgoCD login and create App**

- Cluster rke > Namespaces > Select argocd > Move to DEVOPS Project
- Cluster rke > System > Resources > Workloads > nginx-ingress-controller > ... > Edit
- Show Advanced options > Command > Command > Add "--enable-ssl-passthrough" to the end of arguments > Save

- Login argoCD : https://argocd.vm02
- ID : admin
- Password : # Get admin password

Option1)

**@vm01**

~~~
$ k apply -f charts/tekton/argo-app-kw-mvn.yml
~~~

Option2)

- Manage > Reposotories > Connect Repo Using HTTPS > Project : default 
- Repository URL : http://gitea.gitea:3000/tekton/kw-mvn-deploy.git
- Username: tekton, Password: 12345678 > Connect
- ... > Create Application > Application Name : kw-mvn-deploy > Project Name : default
- Revison > main > Path : .
- Cluster URL : https://kubernetes.default.svc
- Namespace : deploy
- Directory Recurse : Check > Create
- Sync > Auto-create Namespace : Check

&nbsp;

**5) Create argocd-token**
- Rancher > Cluster rke > DEVOPS > Resource > Config > argocd-cm > Edit 
- add data >
  Key: accounts.admin Value: apiKey, login
- Save

- Login argocd : https://argocd.vm02
- Manage > Account > admin > Tokens > Generate New
- Copy New Token:

- Login vm01
- $ vi charts/tekton/argo-token.sh
- Replace ARGOCD_AUTH_TOKEN value with New Token value and wq
- $ charts/tekton/argo-token.sh

&nbsp;

**6) Run Pipeline**
~~~
$ kcg
$ kc rke
$ kn build
$ k create -f charts/tekton/pipeline/pr-kw-build.yml
$ tkn pr logs -f 
~~~
- http://tekton.vm02/#/namespaces/build/pipelineruns

&nbsp;

- Check application : http://vm02:30088/ 
  
**7) Add Webhook to Gitea Repo**
- http://gitea.vm02/tekton/kw-mvn
- Settings > Webhooks > Add Webhook > Gitea
- Target URL : http://el-build-listener.build:8080
- Add Webhook
- Click Webhook > Test Delivery
- Check Pipeline Runs

&nbsp;

**8) Git push source repo will trigger tekton pipeline**
- Edit source and commit
- Check Pipeline Runs
- Check argocd app deployment status
- Check application : http://vm02:30088/ 

&nbsp;

