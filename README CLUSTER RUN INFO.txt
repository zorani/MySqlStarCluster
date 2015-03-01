##############################################
#       A SIMPLE CLUSTER DESIGN              #
##############################################
# master  = mgm node                         #
# node001 = data node                        #
# node002 = sqlnode                          #
##############################################

##############################################
# Config Location for  SQL Node & Data Nodes #
##############################################
#
#
#  Place in following location:
#
#  /etc/my.cnf
#
##############################################
#  Config File Location For Management Node  #
##############################################
#
#  Whats the file name?
#  Answer: config.ini
#
#  Which node?  
#  Answer: Master.
#
#  Which location?
#  Answer: /var/lib/mysql-cluster/config.ini
##############################################


##############################################
#  INFO on files in this Directory           #
##############################################
#  NOTE: Config files for each node are created in each of the following scripts.
#        Modify config entries to suit your cluster design.
#        
#
#  DataNode.sh                   : Run this setup script on each of your data nodes
#  ManagementNode.sh             : Run this setup script on the management node / master node
#  SQLNode.sh                    : Run thus setup script on each of your SQL nodes
#  READEME CLUSTER RUN INFO.txt  : This file.
#
###############################################





#####################################
#####  Running & Testing  ###########
#####################################


#STARTUP ORDER
##############

#IMPORTANT! Startup order matters.
#Start nodes in the following order.


#1) Management / Master node
#2) Data nodes
#3) SQL nodes

The management node should be started first, followed by the data nodes, and then finally by SQL nodes.

#STARTUP COMMANDS
#################

# 1) Starting The Management Node:
#    /> ndb_mgmd -f /var/lib/mysql-cluster/config.ini

Note: Configuration file should be pointed (using -f ) in the initial start up only.   

# 2) Starting The Data Nodes:
#    /> ndbd

# 3) Starting The SQL Nodes 
#    /> pkill -9 mysql
#    /> sudo service mysql.server start

#CHECK YOUR CLUSTER
#######################################
#root@master:~# ndb_mgm
#-- NDB Cluster -- Management Client --
#ndb_mgm> show
#Connected to Management Server at: localhost:1186
#Cluster Configuration
#---------------------
#[ndbd(NDB)]	1 node(s)
#id=2	@172.31.32.72  (mysql-5.6.21 ndb-7.3.7, Nodegroup: 0, *)
#
#[ndb_mgmd(MGM)]	1 node(s)
#id=1	@172.31.32.73  (mysql-5.6.21 ndb-7.3.7)
#
#[mysqld(API)]	1 node(s)
#id=3	@172.31.32.71  (mysql-5.6.21 ndb-7.3.7)

#ndb_mgm> 


######################################################################### 
# SQL User setup - you might want access external from the cluster      #
#########################################################################
#
# mysql -h node001 -u root
#
# CREATE USER 'root'@'%' IDENTIFIED BY '';
# GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
#
# you can now connect to a cluster sql node from scripts outside datanode




