#!/bin/bash
source /vagrant/environment.sh
sudo rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
sudo yum -y install zabbix-agent java
sudo sed -i 's/Server=127.0.0.1/'"Server=$SERVER_IP"'/' /etc/zabbix/zabbix_agentd.conf
sudo sed -i 's/ServerActive=127.0.0.1/'"ServerActive=$SERVER_IP"'/' /etc/zabbix/zabbix_agentd.conf
sudo systemctl start zabbix-agent
wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.47/bin/apache-tomcat-8.5.47.tar.gz
sudo tar -xf apache-tomcat-8.5.47.tar.gz -C /opt/
sudo cp /vagrant/sample.war /opt/apache-tomcat-8.5.47/webapps/
sudo chmod -R 777 /opt/
sudo cp /vagrant/tomcat-catalina-jmx-remote-8.5.47.jar /opt/apache-tomcat-8.5.47/lib/
sudo touch /opt/apache-tomcat-8.5.47/bin/setenv.sh
cat <<add> /opt/apache-tomcat-8.5.47/bin/setenv.sh
CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=12345 -Dcom.sun.management.jmxremote.rmi.port=12346 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=192.168.56.222"
add
sed -i '/<Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" \/>/a <Listener className="org.apache.catalina.mbeans.JmxRemoteLifecycleListener" rmiRegistryPortPlatform="8097" rmiServerPortPlatform="8098" \/>' /opt/apache-tomcat-8.5.47/conf/server.xml
sudo /opt/apache-tomcat-8.5.47/bin/catalina.sh start


