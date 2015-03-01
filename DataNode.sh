#!/bin/sh

####################################
# DATA Node
####################################

export DEBIAN_FRONTEND=noninteractive
rm -rf /var/lib/mysql
rm -rf /etc/mysql/

apt-get -y remove mysql*
apt-get -y --purge remove
apt-get -y autoremove
dpkg --get-selections | grep mysql
aptitude -y purge $(dpkg --get-selections | grep deinstall | sed s/deinstall//)



sudo apt-get -y install libaio1 libaio-dev

groupadd mysql
useradd -g mysql mysql

cd /var/tmp/

wget http://dev.mysql.com/get/Downloads/MySQL-Cluster-7.3/mysql-cluster-gpl-7.3.7-linux-glibc2.5-x86_64.tar.gz

tar -xvzf mysql-cluster-gpl-7.3.7-linux-glibc2.5-x86_64.tar.gz

cp /var/tmp/mysql-cluster-gpl-7.3.7-linux-glibc2.5-x86_64/bin/ndbd /usr/local/bin/ndbd

cp /var/tmp/mysql-cluster-gpl-7.3.7-linux-glibc2.5-x86_64/bin/ndbmtd /usr/local/bin/ndbmtd


mkdir -p /usr/local/mysql/data
rm -f /etc/mysql/my.cnf
rm -f /usr/local/mysql/my.cnf

cat > /etc/my.cnf << EOF

#####################################
# Config for  SQL Node & Data Nodes #
#####################################
#
#
#  Place in following location:
#
#  /etc/my.cnf
#
#



[mysqld]
ndbcluster                      


[mysql_cluster]
ndb-connectstring=master  

EOF

ndbd
