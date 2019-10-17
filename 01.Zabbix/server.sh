#!/bin/bash
source /vagrant/environment.sh
sudo yum -y install mariadb mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb.service
sudo ln -s /usr/bin/resolveip /usr/libexec/resolveip
sudo mysql_install_db --user=mysql
/usr/bin/mysql_install_db --user=mysql
sudo rpm -Uvh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-1.el7.centos.noarch.rpm
sudo yum -y install zabbix-server-mysql zabbix-web-mysql
mysql -uroot -p$DB_PASSWD <<EOF
create database $DB_NAME character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by '$DB_PASSWD';
EOF
sudo zcat /usr/share/doc/zabbix-server-mysql-3.4.*/create.sql.gz | mysql -uroot -p$DB_PASSWD $DB_NAME
sudo sed -i 's/# DBHost=localhost/"DBHost=$SERVER_IP"/' /etc/zabbix/zabbix_server.conf
sudo sed -i 's/# DBPassword=/"DBPassword=$DB_PASSWD"/' /etc/zabbix/zabbix_server.conf
sudo sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone Europe\/Minsk/' /etc/httpd/conf.d/zabbix.conf
cat <<add>>/etc/httpd/conf/httpd.conf
<VirtualHost *:80>
DocumentRoot /usr/share/zabbix
</VirtualHost> 
add
sudo systemctl start httpd
sudo systemctl enable httpd
