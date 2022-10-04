### Lab 7. Cloud Native CI/CD with tekton and argocd

**0) Install Gitea, Docker Registry**

- add hostnames in local hosts file : 
  %YOUR VM02 IP% gitea.vm02 nexus.vm02 tekton.vm02 argocd.vm02
- Login k8sadm@vm01

~~~
$ kc rke
$ kcg
$ k apply -f charts/gitea/deploy-gitea.yml
~~~

- http://gitea.vm02
- Set Gitea Base URL : http://gitea.vm02
- Install Gitea
- Register User ID : tekton, Password: 12345678
- New migration > Git > https://github.com/flytux/kw-mvn.git
- New migration > Git > https://github.com/flytux/kw-mvn-deploy.git
~~~
$ # Add gitea dns name to coredns
$ k edit cm coredns -n kube-system
$ # Add below
    health {
          lameduck 5s
    }
    
     hosts {
        10.128.0.56 gitea.vm02
        fallthrough
     }
$ :wq
~~~
- Install Docker Registry & Docker In-secure Setttings
~~~
$ helm install docker-registry -f charts/docker-registry/values.yaml charts/docker-registry -n registry --create-namespace
$ curl -v vm02:30005/v2/_catalog

$ sudo cp config/daemon.json /etc/docker
$ sudo systemctl restart docker

$ sudo docker login vm02:30005
# ID / Password > tekton / 1 

$ scp config/daemon.json k8sadm@vm02:/home/k8sadm/
$ ssh vm02

$ sudo cp daemon.json /etc/docker/
$ sudo systemctl restart docker

$ sudo docker login vm02:30005
# ID / Password > tekton / 1 
~~~

**1) Install Tekton, Dashboard, Triggers**

~~~
$ kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.29.1/release.yaml
$ k apply -f charts/tekton/tekton-dashboard-release.yaml
$ kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/previous/v0.17.1/release.yaml
$ kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/previous/v0.17.1/interceptors.yaml
~~~
- http://tekton.vm02


**2) Install Pipeline**

~~~
$ k create ns build
$ kn build
$ k apply -f charts/tekton/pipeline
$ tkn t ls
$ tkn p ls
~~~

**3) Install argoCD**
~~~
$ kubectl create namespace argocd
$ kubectl apply -n argocd -f charts/argocd/
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d # Get admin password
~~~

**4) argoCD login and create App**

- Cluster rke > System > Resources > Workloads > nginx-ingress-controller > ... > Edit
- Show Advanced options > Command > Command > Add "--enable-ssl-passthrough" to the end of arguments > Save

- Login argoCD : https://argocd.vm02
- ID : admin
- Password : # Get admin password
- Manage > Reposotories > Connect Repo Using HTTPS > Project : default 
- Repository URL : http://gitea.gitea:3000/tekton/kw-mvn-deploy.git
- Username: tekton, Password: 12345678 > Connect
- ... > Create Application > Application Name : kw-mvn > Project Name : default
- Revison > main > Path : .
- Cluster URL : https://kubernetes.default.svc
- Namespace : deploy
- Directory Recurse : Check > Create
- Select App: kw-mvn > Sync > Auto-create Namespace : Check > Syncronize

**5) Create argocd-token**
- Rancher > Cluster rke > Devops > Resource > Config > argocd-cm > Edit 
- add data >
  Key: accounts.admin: Value: apiKey, login
- Save

- Login argocd : https://argocd.vm02
- Manage > Account > admin > Tokens > Generate New
- Copy New Token:

- Login vm01
- $  charts/tekton/argo-token.sh
- Replace ARGOCD_AUTH_TOKEN value with New Token value and wq
- $ charts/tekton/argo-token.sh


**6) Run Pipeline**
~~~
$ kcg
$ kc rke
$ kn build
$ k create -f charts/tekton/pipeline/pr-kw-build.yml
$ tkn pr logs -f 
~~~
- http://tekton.vm02/#/namespaces/build/pipelineruns
  
**7) Add Webhook to Gitea Repo**
- http://gitea.vm02/tekton/kw-mvn
- Settings > Webhooks > Add Webhook > Gitea
- Target URL : http://el-build-listener.build:8080
- Add Webhook
- Click Webhook > Test Delivery
- Check Pipeline Runs

**7) Git push source repo triggiers tekton**
- edit source and commit
- Check Pipeline Runs
- Check argocd app deployment status
- Check application : http://vm02:30088/ 
