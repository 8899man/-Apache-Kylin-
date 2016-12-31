1. ��ѹ��������
[root@dockerb ~]# tar -zxvf mysql-advanced-5.6.21-linux-glibc2.5-x86_64.tar.gz -C /usr/local/
[root@dockerb ~]# cd /usr/local/
[root@dockerb local]# ln -s mysql-advanced-5.6.21-linux-glibc2.5-x86_64 mysql
[root@dockerb local]# cd mysql
[root@dockerb mysql]# mkdir logs
[root@dockerb mysql]# cp support-files/my-default.cnf /etc/my.cnf

�����޸�/etc/my.cnf�ļ�������Ϊ��
[mysqld]
transaction-isolation = READ-COMMITTED
# Disabling symbolic-links is recommended to prevent assorted security risks;
# to do so, uncomment this line:
# symbolic-links = 0
key_buffer_size = 32M
max_allowed_packet = 32M
thread_stack = 256K
thread_cache_size = 64
query_cache_limit = 8M
query_cache_size = 64M
query_cache_type = 1
max_connections = 550
#expire_logs_days = 10
#max_binlog_size = 100M
#log_bin should be on a disk with enough free space. Replace '/var/lib/mysql/mysql_binary_log' with an appropriate path for your system
#and chown the specified folder to the mysql user.
log_bin=/usr/local/mysql/logs/mysql_binary_log
# For MySQL version 5.1.8 or later. Comment out binlog_format for older versions.
binlog_format = mixed
read_buffer_size = 2M
read_rnd_buffer_size = 16M
sort_buffer_size = 8M
join_buffer_size = 8M
# InnoDB settings
innodb_file_per_table = 1
innodb_flush_log_at_trx_commit  = 2
innodb_log_buffer_size = 64M
innodb_buffer_pool_size = 4G
innodb_thread_concurrency = 8
innodb_flush_method = O_DIRECT
innodb_log_file_size = 512M
explicit_defaults_for_timestamp
[mysqld_safe]
log-error=/usr/local/mysql/logs/mysqld.log
pid-file=/usr/local/mysql/data/mysqld.pid
sql_mode=STRICT_ALL_TABLES


2. ��װMySQL��
[root@dockerb mysql]# scripts/mysql_install_db --user=root

3. ���û�������
��/etc/profile�ļ�������MySQL��������:
[root@dockerb mysql]# vi /etc/profile
export MYSQL_HOME=/usr/local/mysql
export PATH=$MYSQL_HOME/bin:$PATH
[root@dockerb mysql]# source /etc/profile

4. ����MySQL
[root@dockerb mysql]# mysqld_safe --user=root &

5. ����root����(dockerbΪMySQL��������������)
[root@dockerb mysql]# mysqladmin -u root password 'root'
[root@dockerb mysql]# mysqladmin -u root -h dockerb  password 'root'

6. ��֤
[root@dockerb mysql]# lsof -i :3306        #MySQL���ڼ���״̬
COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
mysqld  5123 root   11u  IPv6 227432      0t0  TCP *:mysql (LISTEN)


[root@dockerb mysql]# mysql -uroot -proot -e "status" #�鿴״̬
Warning: Using a password on the command line interface can be insecure.
--------------
mysql  Ver 14.14 Distrib 5.6.21, for linux-glibc2.5 (x86_64) using  EditLine wrapper

Connection id:		4
Current database:	
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		5.6.21-enterprise-commercial-advanced-log MySQL Enterprise Server - Advanced Edition (Commercial)
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	latin1
Db     characterset:	latin1
Client characterset:	utf8
Conn.  characterset:	utf8
UNIX socket:		/tmp/mysql.sock
Uptime:			1 min 11 sec

Threads: 1  Questions: 15  Slow queries: 0  Opens: 70  Flush tables: 1  Open tables: 63  Queries per second avg: 0.211
--------------


7. Ϊ�˷��������ͣMySQL������д�����ű�
start-mysql�ű�����Ϊ��
#!/bin/bash
mysqld_safe --user=root &

stop-mysql�ű�����Ϊ��
#!/bin/bash
mysqladmin -uroot -proot shutdown -S /tmp/mysql.sock

���Խ��������ű��ŵ�ϵͳ��binĿ¼���棬����/usr/bin��/user/sbin����mysql�İ�װ��binĿ¼���沢���ÿ�ִ��Ȩ�ޣ�
����������ŵ�/usr/local/mysql/bin���棬��Ϊ���·�����Ѿ����뵽PATH����:
[root@dockerb bin]# chmod +x start-mysql
[root@dockerb bin]# chmod +x stop-mysql

��������֤һ�£�
[root@dockerb bin]# stop-mysql
[root@dockerb bin]# lsof -i :3306  #�Ѿ��鿴��������״̬��

������һ�£�
[root@dockerb bin]# start-mysql 
[root@dockerb bin]# lsof -i :3306
COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
mysqld  6090 root   11u  IPv6 244642      0t0  TCP *:mysql (LISTEN)

���������ˡ�
