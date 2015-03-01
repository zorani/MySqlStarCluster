#!/bin/sh

####################################
#             SQL Node             #
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

cp -r /var/tmp/mysql-cluster-gpl-7.3.7-linux-glibc2.5-x86_64/ /usr/local/

ln -s /usr/local/mysql-cluster-gpl-7.3.7-linux-glibc2.5-x86_64/ /usr/local/mysql-cluster


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

[mysqld]
basedir=/usr/local/mysql-cluster/

EOF

#NOTE: About non-default installs.
#Moving database away from default location /var/lib/mysql will generate errors when
#running mysql_install_db, until you,
#update the usr.sbin.mysql file in /etc/apparmor.d/ , then run 
#/etc/init.d/apparmor restart



cat > /etc/apparmor.d/usr.sbin.mysqld << EOF

/usr/local/mysql-cluster/data/ r,
/usr/local/mysql-cluster/data/** rwk,


EOF

service apparmor reload



/usr/local/mysql-cluster/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql-cluster/ --datadir=/usr/local/mysql-cluster/data/ --defaults-file=/etc/my.cnf 


cp /usr/local/mysql-cluster/bin/mysqld_safe /usr/bin/
cp /usr/local/mysql-cluster/bin/mysql /usr/bin/

cd /usr/local/mysql-cluster

chown -R root .
chown -R mysql data
chgrp -R mysql .

cp /usr/local/mysql-cluster/support-files/mysql.server /etc/init.d/

#need to set the following variables in file /etc/init.d/mysql.server to  
#basedir=/usr/local/mysql-cluster/
#datadir=/usr/local/mysql-cluster/data/

sed -i 's/^basedir=$/basedir=\/usr\/local\/mysql-cluster\//g' /etc/init.d/mysql.server
sed -i 's/^datadir=$/datadir=\/usr\/local\/mysql-cluster\/data\//g' /etc/init.d/mysql.server


cd /etc/init.d/

update-rc.d mysql.server defaults

rm -rf /var/tmp/*

service mysql.server start

