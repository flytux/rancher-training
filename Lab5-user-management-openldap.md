Lab 5. User management with keycloak

- install ldap
  helm install openldap -f values.yaml . -n openldap --set replicaCount=1 --set phpldapadmin.ingress.hosts[0]=ldapadmin.vm02 
- keycloak create user / realm
- keycloak oidc setting
- rancher setting
- check login
