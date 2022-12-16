### Lab 1. Install Rancher Quick-Start

**0. 사전작업 **

- vm01과 vm02에 root로 로그인합니다.
- setup.sh 파일을 편집하여 vm01, vm02 IP를 할당된 IP값으로 수정합니다.

**@vm01 && @vm02**

```bash
$ ./setup.sh
```

- vm01에 계정 : k8sadm, 암호 : 1 로 로그인 합니다.

**@vm01**

```bash
$ ssh-keygen
$ ssh-copy-id vm01
$ ssh-copy-id vm02
```

- Lab 문서와 소스를 다운 받습니다.

```bash
$ wget https://github.com/flytux/rancher-training/archive/refs/tags/rev2.zip
$ cd rancher-training-rev2
```

- 옵션 1) zsh 환경 설정
```bash
$ tar xvf charts/code-server/scripts/dev-shell.tgz -C ~
$ zsh
```

- 옵션 2) bash 쉘 환경 설정
```bash
$ cat config/bashrc-k8s >> ~/.bashrc
$ source ~/.bashrc
```

**1. Install rancher quick-start**

```bash
$ docker run -d --name rancher --privileged -p 8080:80 -p 8443:443 rancher/rancher
$ docker logs  rancher  2>&1 | grep "Bootstrap Password:"
```

- 웹브라우저로 http://vm01:8080 를 접속합니다.
- 암호 변경
- Cluster : local > Copy KubeConfig to Clipboard를 선택합니다.

```bash
$ mkdir ~/.kube
$ vi ~/.kube/config
# 클립보드 복사 내용을 붙여 녛고 저장합니다.
```

**2. Cluster 정보 확인**

```bash
$ kubectl get pods -A
$ kubectl get nodes
$ kubectl get cs
$ kubectl cluster-info
```

**3. 워크로드 **

```bash
$ kubectl create deployment nginx --image nginx --port 80
$ kubectl expose deployment nginx
$ kubectl get svc
$ kubectl get pods
$ kubectl exec -it $(kubectl get pods -l app=nginx -o name) -- bash
$ curl -v nginx
```

