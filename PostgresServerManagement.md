# Installing PostgreSQL 12 in CentOS 7
## References
[Install CentOS on VirtualBox on Windows Host and Connect from PuTTY](https://medium.com/@jithz/install-centos-on-virtualbox-on-windows-host-and-connect-from-putty-d047afda2788)  
[How to install PostgreSQL 12 on Centos 7](https://computingforgeeks.com/how-to-install-postgresql-12-on-centos-7/)  
[Connect to postgresql database in linux virtualbox from Windows](https://stackoverflow.com/questions/18121666/connect-to-postgresql-database-in-linux-virtualbox-from-win7)  
[How to stop and disable firewalld on Centos7](https://linuxize.com/post/how-to-stop-and-disable-firewalld-on-centos-7/)  
[Upgrade Postgresql from 11 to 13 on Centos-7](https://feriman.com/upgrade-postgresql-from-11-to-13-on-centos-7/)  
[How to install postgresql 14 centos rhel 7](https://computingforgeeks.com/how-to-install-postgresql-14-centos-rhel-7/)  

## Important paths
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

# Firewall issues
There are several tutorials how to connect to your database, that is in loacal VM but it may turn out tricky if the CentOS firewall is there. Here is how to disable it. In references, there is also webpage with longer description
## Disable temporary
```
[root@localhost dbuser]# sudo firewall-cmd --state
running
[root@localhost dbuser]# sudo systemctl stop firewalld
[root@localhost dbuser]# sudo firewall-cmd --state
not running
````
## Disable permanently
```
[root@localhost dbuser]# sudo systemctl stop firewalld
[root@localhost dbuser]# sudo systemctl disable firewalld
Removed symlink /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed symlink /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
[root@localhost dbuser]# sudo systemctl mask --now firewalld
Created symlink from /etc/systemd/system/firewalld.service to /dev/null.
[root@localhost dbuser]#
```

# Upgrading postgres from 12 to 14
If you already have PG12, then all preparational works should be done but otherwise check link [How to install postgresql 14 centos rhel 7](https://computingforgeeks.com/how-to-install-postgresql-14-centos-rhel-7/)  
So we can continue, by installing the Postgres 14 and necessary packages
```bash
sudo yum install -y postgresql14-server postgresql14-contrib postgresql14-plpython3 postgresql14-pglogical postgresql14
```
After installation, database initialization is required before service can be started.  
```
[root@localhost dbuser]# sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
Initializing database ... OK
```
Stop Postgresql12 and check over
```
sudo systemctl stop postgresql-12
sudo systemctl status postgresql-12
```
Now change user to postgres 
```
su - postgres
cd
```
**Run preupgrade check**
```
/usr/pgsql-14/bin/pg_upgrade --old-bindir=/usr/pgsql-12/bin --new-bindir=/usr/pgsql-14/bin --old-datadir=/var/lib/pgsql/12/data --new-datadir=/var/lib/pgsql/14/data --user=postgres --link --check
```
**UPGRADE**
```
 /usr/pgsql-14/bin/pg_upgrade --old-bindir=/usr/pgsql-12/bin --new-bindir=/usr/pgsql-14/bin --old-datadir=/var/lib/pgsql/12/data --new-datadir=/var/lib/pgsql/14/data --user=postgres --link
```
TODO : Maybe config files needs to be adjusted.

If you are done with these config files, restart the service and add autostart
```
systemctl restart postgresql-14
systemctl enable postgresql-14
```

**Removing old version if upgrade is successful**
At this point, you have to test your application. You need to restart your application (GitLab or whatever you use). If everything is working fine, let's continue by removing old packages and files:
```
sudo yum remove postgresql11*
rm -rf /var/lib/pgsql/12
su - postgres -c "/var/lib/pgsql/delete_old_cluster.sh" 
```
