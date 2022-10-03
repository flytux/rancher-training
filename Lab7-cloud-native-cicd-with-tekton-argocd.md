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
- Register User
- New migration URL : https://github.com/flytux/kw-mvn.git

~~~
$ helm install docker-registry -f charts/docker-registry/values.yaml charts/docker-registry -n registry --create-namespace
$ curl -v vm02:30005/v2/_catalog
~~~

**1) Install Tekton, Dashboard, Triggers**

~~~
$ kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.29.1/release.yaml
$ k apply -f charts/tekton/tekton-dashboard-release.yaml
$ kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/previous/v0.17.1/release.yaml
$ kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/previous/v0.17.1/interceptors.yaml
~~~
- http://tekton.vm02



