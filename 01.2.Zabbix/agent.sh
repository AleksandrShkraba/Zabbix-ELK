#!/bin/bash
source /vagrant/environment.sh
sudo rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
sudo yum -y install zabbix-agent
sudo sed -i 's/Server=127.0.0.1/'"Server=$SERVER_IP"'/' /etc/zabbix/zabbix_agentd.conf
sudo sed -i 's/ServerActive=127.0.0.1/'"ServerActive=$SERVER_IP"'/' /etc/zabbix/zabbix_agentd.conf
sudo systemctl start zabbix-agent
wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.47/bin/apache-tomcat-8.5.47.tar.gz
sudo yum install zabbix-sender
zabbix_sender -vv -z 192.168.56.111 -p 10051 -s LinuxVM -k trap -o Hello







