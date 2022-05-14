# Installing PostgreSQL 12 in CentOS 7
## References
[Install CentOS on VirtualBox on Windows Host and Connect from PuTTY](https://medium.com/@jithz/install-centos-on-virtualbox-on-windows-host-and-connect-from-putty-d047afda2788)  
[How to install PostgreSQL 12 on Centos 7](https://computingforgeeks.com/how-to-install-postgresql-12-on-centos-7/)  
[Connect to postgresql database in linux virtualbox from Windows](https://stackoverflow.com/questions/18121666/connect-to-postgresql-database-in-linux-virtualbox-from-win7)
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
# Installing extensions
Update yum database  
```
sudo yum makecache
```
Check the available extension package
```
[dbuser@localhost ~]$ sudo yum list available | grep 'plpy'
[sudo] password for dbuser:
postgresql10-plpython.x86_64             10.21-1PGDG.rhel7               pgdg10
postgresql10-plpython3.x86_64            10.21-1PGDG.rhel7               pgdg10
postgresql11-plpython.x86_64             11.16-1PGDG.rhel7               pgdg11
postgresql11-plpython3.x86_64            11.16-1PGDG.rhel7               pgdg11
postgresql12-plpython.x86_64             12.11-1PGDG.rhel7               pgdg12
postgresql12-plpython3.x86_64            12.11-1PGDG.rhel7               pgdg12
postgresql13-plpython3.x86_64            13.7-1PGDG.rhel7                pgdg13
postgresql14-plpython3.x86_64            14.3-1PGDG.rhel7                pgdg14
```
Install extension into linux
```
[dbuser@localhost ~]$ sudo yum -y install postgresql12-plpython3

```
Look over if the extension is now available
```
postgres=# select * from pg_available_extensions;
       name        | default_version | installed_version |                  comment
-------------------+-----------------+-------------------+-------------------------------------------
 plpgsql           | 1.0             | 1.0               | PL/pgSQL procedural language
 hstore_plpython3u | 1.0             |                   | transform between hstore and plpython3u
 jsonb_plpython3u  | 1.0             |                   | transform between jsonb and plpython3u
 ltree_plpython3u  | 1.0             |                   | transform between ltree and plpython3u
 plpython3u        | 1.0             |                   | PL/Python3U untrusted procedural language
(5 rows)

```
Create extension
```
postgres=# create extension plpython3u;
CREATE EXTENSION
```
Check if it is available
```
postgres=# select * from pg_extension;
  oid  |  extname   | extowner | extnamespace | extrelocatable | extversion | extconfig | extcondition
-------+------------+----------+--------------+----------------+------------+-----------+--------------
 14173 | plpgsql    |       10 |           11 | f              | 1.0        |           |
 16384 | plpython3u |       10 |           11 | f              | 1.0        |           |
(2 rows)
```
