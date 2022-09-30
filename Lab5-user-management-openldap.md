### Lab 5. User management with openLDAP

**0) Multi-cluster context settings**

- https://rancher.vm01/
- Cluster > rke > Kubeconfig File > Copy to clipboard
- Login k8sadm@vm01
~~~
$ vi ~/.kube/config-rke
~~~
- paste & save (wq)
~~~
$ export KUBECONFIG=$HOME/.kube/config:$HOME/.kube/config-rke
$ kcg
$ kc rke
~~~

**1) install ldap**

~~~
$ helm install openldap -f charts/openldap/values.yaml charts/openldap -n openldap --create-namespace
~~~

**2) Login to phpldapadmin & create group / users**

- http://ldapadmin.vm02
- Login with password "admin"
- select dc=sso in left pane
- create child entry > Generic: Organisational Unit > type "groups" > create object > commit
- select dc=sso in left pane
- create a child entry > Generic: Organisational Unit > type "users" > create object > commit
- select "ou=groups" in left pane
- create a child entry > Generic: POSIX Group > type "ldapusers" > create object > commit
- select "ou=users" in left pane
- create a child entry > Generic: User Account > type first name, last name, password > select gid "ldapusers" > create object > commit
- remeber username & password

**3) Rancher authenticate settings** 
- https://rancher.vm01/g/security/authentication/openldap
- Hostname or IP address > VM's Internal IP (ex. 10.128.0.55)
- Port : 30389
- Service Account Distinguished Name : cn=admin,dc=sso,dc=kubeworks,dc=net, Service Account Password : admin
- User Search Base : ou=users,dc=sso,dc=kubeworks,dc=net
- Group Search Base : ou=groups,dc=sso,dc=kubeworks,dc=net
- Click "Authenticate with OpenLDAP

**4) Login with LDAP**
- https://rancher.vm01 login with LDAP user name & password

