#!/bin/bash
source /vagrant/environment.sh
sudo rpm -Uvh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-1.el7.centos.noarch.rpm
sudo yum -y install zabbix-agent
sudo sed -i 's/Server=127.0.0.1/"Server=$SERVGER_IP"/' /etc/zabbix/zabbix_agentd.conf
sudo sed -i 's/ServerActive=127.0.0.1/"ServerActive=$SERVGER_IP"/' /etc/zabbix/zabbix_agentd.conf
sudo systemctl start zabbex-agent
