gadmin start infra
gadmin start all
gadmin config set Security.LDAP.Enable true
gadmin config set Security.LDAP.Hostname localhost
gadmin config set Security.LDAP.BaseDN "dc=tigergraph,dc=com"
gadmin config set Security.LDAP.SearchFilter "(objectClass=*)"
gadmin config set Security.LDAP.AdminDN "cn=admin,dc=tigergraph,dc=com"
gadmin config set Security.LDAP.AdminPassword "admin"
gadmin config set RESTPP.Factory.EnableAuth true
gadmin config apply -y
gadmin restart gsql gui nginx restpp -y