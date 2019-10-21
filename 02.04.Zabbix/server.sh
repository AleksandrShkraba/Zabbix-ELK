#!/bin/bash
source /vagrant/environment.sh
sudo yum -y install mariadb mariadb-server
sudo ln -s /usr/bin/resolveip /usr/libexec/resolveip
/usr/bin/mysql_install_db --user=mysql --force
sudo systemctl start mariadb
sudo systemctl enable mariadb.service
sudo rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
sudo yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-agent
sudo yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-agent
sudo yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-agent
sudo yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-agent
sudo yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-agent
sudo yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-agent
mysql -uroot -e "create database $DB_NAME character set utf8 collate utf8_bin" 
mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost identified by '$DB_PASSWD'"
sudo zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -u$DB_USERNAME -p$DB_PASSWD $DB_NAME
sudo sed -i 's/# DBPassword=/'"DBPassword=$DB_PASSWD"'/' /etc/zabbix/zabbix_server.conf
sudo sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone Europe\/Minsk/' /etc/httpd/conf.d/zabbix.conf
sudo cp -f /vagrant/zabbix.conf.php /etc/zabbix/web/
cat <<add>>/etc/httpd/conf/httpd.conf
<VirtualHost *:80>
DocumentRoot /usr/share/zabbix
</VirtualHost> 
add
sudo systemctl restart zabbix-server zabbix-agent httpd
sudo systemctl enable zabbix-server zabbix-agent httpd
