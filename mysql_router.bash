

###copy these files RPMs from 172.22.5.101 to 172.22.5.104  
mysql-commercial-client-8.0.25-1.1.el8.x86_64.rpm
mysql-commercial-client-plugins-8.0.25-1.1.el8.x86_64.rpm 
mysql-commercial-libs-8.0.25-1.1.el8.x86_64.rpm 
mysql-commercial-common-8.0.25-1.1.el8.x86_64.rpm


cd /home/cprdbkd01a/mysql-bin
sudo yum install mysql-commercial-client-8.0.25-1.1.el8.x86_64.rpm mysql-commercial-client-plugins-8.0.25-1.1.el8.x86_64.rpm 
     mysql-commercial-libs-8.0.25-1.1.el8.x86_64.rpm mysql-commercial-common-8.0.25-1.1.el8.x86_64.rpm

sudo vim /etc/hosts

172.22.5.101    node01
172.22.5.102    node02
172.22.5.103    node03


sudo mysqlrouter --bootstrap admin@node01:3306 --user=mysqlrouter

        Please enter MySQL password for admin:
        # Bootstrapping system MySQL Router instance...
        
        - Creating account(s) (only those that are needed, if any)
        - Verifying account (using it to run SQL queries that would be run by Router)
        - Storing account in keyring
        - Adjusting permissions of generated files
        - Creating configuration /etc/mysqlrouter/mysqlrouter.conf
        
        Existing configuration backed up to '/etc/mysqlrouter/mysqlrouter.conf.bak'
        
        # MySQL Router configured for the InnoDB Cluster 'ProdCluster1'
        
        After this MySQL Router has been started with the generated configuration
        
            $ /etc/init.d/mysqlrouter restart
        or
            $ systemctl start mysqlrouter
        or
            $ mysqlrouter -c /etc/mysqlrouter/mysqlrouter.conf
        
        the cluster 'ProdCluster1' can be reached by connecting to:
        
        ## MySQL Classic protocol
        
        - Read/Write Connections: localhost:6446
        - Read/Only Connections:  localhost:6447
        
        ## MySQL X protocol
        
        - Read/Write Connections: localhost:6448
        - Read/Only Connections:  localhost:6449


sudo systemctl status mysqlrouter
sudo systemctl start mysqlrouter


#### for TESTING Read/Write port
mysql -uadmin -p -h127.0.0.1 -P6446 -p123_123Abc
mysql> SELECT @@hostname, @@port;

#### Read/Only port
mysql -uadmin -p -h127.0.0.1 -P6447 -p123_123Abc
mysql> SELECT @@hostname, @@port;
