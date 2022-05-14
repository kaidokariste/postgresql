# Installing PostgreSQL 12 in CentOS 7
## References
[How to install PostgreSQL 12 on Centos 7](https://computingforgeeks.com/how-to-install-postgresql-12-on-centos-7/)  
## Importand paths
```java
/var/lib/pgsql/12/data/pg_hba.conf  
/var/lib/pgsql/12/data/postgresql.conf
[postgres] /usr/pgsql-12/bin
```
## Set up CentOS based VM in local machine
Download the CentOS image, and set up the VM server.  
Install the openssh server to be able to use putty. Makes thing easier.
```bash
sudo yum –y install openssh-server openssh-clients
```
Check the ip address  
```bash
ip addr
```
Connect using Putty. Its good to makr down also the version.
```bash
[dbuser@localhost ~]$ cat /etc/redhat-release
CentOS Linux release 7.9.2009 (Core)
```

## Install from the PostgreSQL repository
Although there is possibility to use also CentOS repository, then it contains too old versions. Better is to use Postgres official repository.  
Add postgres yum repository to CentOS7
```bash
sudo yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
```
Check avaialable packages
```
[dbuser@localhost ~]$ sudo yum list available |grep 'postgres'
```
Good to check out name of the repository what you need to enable;
If your connection goes through PROXY then you may need to add proxy settings 
```
vim /etc/yum.repos.d/pgdg-redhat-all.repo
```
Install PostgreSQL client and server packages
```
sudo yum -y install epel-release yum-utils
sudo yum-config-manager --enable pgdg12
sudo yum install postgresql12-server postgresql12
```
After installation, database initialization is required before service can be started.  
```
sudo /usr/pgsql-12/bin/postgresql-12-setup initdb
```
Start and enable the database server service.  
```
[dbuser@localhost ~]$ sudo systemctl enable --now postgresql-12
```
Check the status
```
systemctl status postgres-12
```
Restarting when started with system.d
```
[dbuser@localhost ~]$ sudo systemctl restart postgresql-12
```
