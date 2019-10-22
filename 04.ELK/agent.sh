#!/bin/bash
sudo yum -y install wget
#sudo rpm -ivh /vagrant/jdk*
yum install java
wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.47/bin/apache-tomcat-8.5.47.tar.gz
sudo tar -xf apache-tomcat-8.5.47.tar.gz -C /opt/
sudo chmod -R 777 /opt/
sudo /opt/apache-tomcat-8.5.47/bin/catalina.sh start
wget https://artifacts.elastic.co/downloads/logstash/logstash-7.4.0.rpm
rpm -ivh logstash*
chmod -R 777 /opt
sudo touch /etc/logstash/conf.d/my.conf
cat <<add> /etc/logstash/conf.d/my.conf
input {
  file {
    path => "/opt/apache-tomcat-8.5.47/logs/catalina.out"
    start_position => "beginning"
  }
}

output {
  elasticsearch {
    hosts => ["192.168.56.111:9200"]
  }
  stdout { codec => rubydebug }
}
add

sudo systemctl restart logstash
sudo cp /vagrant/sample.war /opt/apache-tomcat-8.5.47/webapps/

sudo /opt/apache-tomcat-8.5.47/bin/catalina.sh stop
sudo /opt/apache-tomcat-8.5.47/bin/catalina.sh start


