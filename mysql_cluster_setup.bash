Username=cprddba01a
Password=Cpr#db@0!a

db:
172.22.5.101
172.22.5.102
172.22.5.103

scp -r /home/mysql cprddba01a@172.22.5.102:/home/cprddba01a/
scp -r /home/mysql cprddba01a@172.22.5.103:/home/cprddba01a/

cp -r /home/mysql /home/cprddba01a/

mkdir mysql-bin
cd mysql-bin

unzip /home/cprddba01a/mysql/V1031503-01.zip
unzip /home/cprddba01a/mysql/V1031683-01.zip

sudo yum localinstall mysql-commercial-server-8.0.25-1.1.el8.x86_64.rpm mysql-commercial-client-8.0.25-1.1.el8.x86_64.rpm mysql-commercial-libs-8.0.25-1.1.el8.x86_64.rpm mysql-commercial-common-8.0.25-1.1.el8.x86_64.rpm mysql-shell-commercial-8.0.25-1.1.el8.x86_64.rpm mysql-commercial-client-plugins-8.0.25-1.1.el8.x86_64.rpm


#sudo yum install epel-release
sudo yum install vim net-tools telnet htop nload
sudo vim /etc/selinux/config
getenforce

sudo vim /etc/hosts

172.22.5.101 node01
172.22.5.102 node02
172.22.5.103 node03

sudo reboot


sudo systemctl stop mysqld

sudo rm -rf /var/lib/mysql
sudo mkdir /data1/mysql
sudo chown -R mysql.mysql /data1/mysql

sudo vim /etc/my.cnf

###
datadir=/data1/mysql
socket=/var/lib/mysql/mysql.sock

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid


binlog_transaction_dependency_tracking  = WRITESET
enforce_gtid_consistency                = ON
gtid_mode                               = ON
server_id                               = 1
slave_parallel_type                     = LOGICAL_CLOCK
slave_preserve_commit_order             = ON

###

sudo mysqld --initialize-insecure --user=mysql

sudo rm -rf /var/lib/mysql
sudo mkdir /var/lib/mysql
sudo chown -R mysql.mysql /var/lib/mysql
sudo systemctl start mysqld

mysql -uroot


#systemctl start mysqld
#systemctl enable mysqld
#grep pass /var/log/mysqld.log

set password = '123_123Abc';

mysql -uroot -p123_123Abc


CREATE USER `admin`@`%` identified by '123_123Abc';
GRANT CREATE USER, FILE, PROCESS, RELOAD, REPLICATION CLIENT, REPLICATION SLAVE, SELECT, SHUTDOWN, SUPER ON *.* TO `admin`@`%` WITH GRANT OPTION;
GRANT DELETE, INSERT, UPDATE ON mysql.* TO `admin`@`%` WITH GRANT OPTION;
GRANT ALTER, ALTER ROUTINE, CREATE, CREATE ROUTINE, CREATE TEMPORARY TABLES, CREATE VIEW, DELETE, DROP, EVENT, EXECUTE, INDEX, INSERT, LOCK TABLES, REFERENCES, SHOW VIEW, TRIGGER, UPDATE ON mysql_innodb_cluster_metadata.* TO `admin`@`%` WITH GRANT OPTION;
GRANT ALTER, ALTER ROUTINE, CREATE, CREATE ROUTINE, CREATE TEMPORARY TABLES, CREATE VIEW, DELETE, DROP, EVENT, EXECUTE, INDEX, INSERT, LOCK TABLES, REFERENCES, SHOW VIEW, TRIGGER, UPDATE ON mysql_innodb_cluster_metadata_bkp.* TO `admin`@`%` WITH GRANT OPTION;
GRANT ALTER, ALTER ROUTINE, CREATE, CREATE ROUTINE, CREATE TEMPORARY TABLES, CREATE VIEW, DELETE, DROP, EVENT, EXECUTE, INDEX, INSERT, LOCK TABLES, REFERENCES, SHOW VIEW, TRIGGER, UPDATE ON mysql_innodb_cluster_metadata_previous.* TO `admin`@`%` WITH GRANT OPTION;
GRANT CLONE_ADMIN, CONNECTION_ADMIN, EXECUTE, GROUP_REPLICATION_ADMIN, PERSIST_RO_VARIABLES_ADMIN, REPLICATION_APPLIER, REPLICATION_SLAVE_ADMIN, ROLE_ADMIN, SYSTEM_VARIABLES_ADMIN ON *.* TO 'admin'@'%' WITH GRANT OPTION;

mysqlsh node01 -u admin
#mysqlsh node02 -u admin
#mysqlsh node03 -u admin

dba.configureLocalInstance("admin@node01:3306");
dba.checkInstanceConfiguration("admin@node01:3306");
var cluster = dba.createCluster('ProdCluster1')
var cluster = dba.getCluster('ProdCluster1')

#### add cluster nodes 
cluster.addInstance("admin@node02:3306")
cluster.addInstance("admin@node03:3306")

cluster.status()

cluster.checkInstanceState()