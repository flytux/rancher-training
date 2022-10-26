### Lab 4. User management with openLDAP


**1) install ldap**

- 퍼시스턴트 볼륨을 이용하기 위하여 기본 스토리지 클래스를 설치합니다.
- 설치된 스토리지 클래스를 기본 클래스로 설정합니다.
- vm02 클러스터에 오픈LDAP을 설치합니다.

~~~
$ k apply -f charts/local-path/local-path-storage.yaml  

- Cluster rke > Storage > StorageClasses > local-path > ... > Set as Default

$ helm install openldap -f charts/openldap/values.yaml charts/openldap -n openldap --create-namespace
~~~

**2) ldapadmin 화면에서 사용자 생성**

- http://ldapadmin.vm02 에 접속합니다.
- 패스워드 "admin" 

- 좌측 창에서 dc=sso 선택
- create child entry > Generic: Organisational Unit > type "groups" > create object > commit
- 좌측 창에서 dc=sso 선택
- create a child entry > Generic: Organisational Unit > type "users" > create object > commit

- 좌측 창에서 "ou=groups" 선택
- create a child entry > Generic: POSIX Group > type "ldapusers" > create object > commit
- 좌측 창에서 "ou=users" 선택
- create a child entry > Generic: User Account > type first name, last name, password > select gid "ldapusers" > create object > commit

- 생성한 사용자 계정과 비밀번호를 기억합니다.


**3) Rancher 외부인증 설정** 

- 메뉴 > Users & Authentication > Auth Provider > OpenLDAP 선택

- Hostname or IP address > VM02 내부 IP (ex. 192.0.212.01)
- Port : 30389

- Service Account Distinguished Name : cn=admin,dc=sso,dc=kubeworks,dc=net, Service Account Password : admin
- User Search Base : ou=users,dc=sso,dc=kubeworks,dc=net
- Group Search Base : ou=groups,dc=sso,dc=kubeworks,dc=net

- LDAP에 생성한 사용자 명과 패스워드를 입력합니다.
- "Enable"로 인증 설정 적용


**4) LDAP 사용자 계정으로 Rancher 로그인**
- Rancher에서 로그아웃합니다.
- LDAP 사용자 계정과 패스워드로 로그인 합니다. 
