#!/bin/sh


#####################################
#Management Node
#####################################

export DEBIAN_FRONTEND=noninteractive
rm -rf /var/lib/mysql
rm -rf /etc/mysql/
rm -f /etc/mysql/my.cnf

apt-get -y remove mysql*
apt-get -y --purge remove
apt-get -y autoremove
dpkg --get-selections | grep mysql
aptitude -y purge $(dpkg --get-selections | grep deinstall | sed s/deinstall//)


cd /var/tmp/


wget http://dev.mysql.com/get/Downloads/MySQL-Cluster-7.3/mysql-cluster-gpl-7.3.7-linux-glibc2.5-x86_64.tar.gz

tar -xvzf mysql-cluster-gpl-7.3.7-linux-glibc2.5-x86_64.tar.gz

cp /var/tmp/mysql-cluster-gpl-7.3.7-linux-glibc2.5-x86_64/bin/ndb_mgm* /usr/local/bin/


rm -rf /var/tmp/*

mkdir -p /var/lib/mysql-cluster/

cat > /var/lib/mysql-cluster/config.ini << EOF

#####################################
#  Config File For Management Node  #
#####################################
#
#  Which node?  
#  Answer: Master.
#
#  Which location?
#  Answer: /var/lib/mysql-cluster/config.ini


[ndbd default]
NoOfReplicas=1   
DataMemory=80M 
IndexMemory=18M  
  
  
[ndb_mgmd]
hostname=master          
datadir=/var/lib/mysql-cluster  

 
[ndbd]
hostname=node001    
datadir=/usr/local/mysql/data   

[mysqld]
hostname=node002 

EOF

ndb_mgmd --configdir=/var/lib/mysql-cluster/ -f /var/lib/mysql-cluster/config.ini




