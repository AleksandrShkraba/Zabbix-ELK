#!/bin/bash
sudo yum install wget
#sudo rpm -ivh /vagrant/jdk*
sudo yum install java
sudo wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.4.0-x86_64.rpm
sudo rpm -ivh elastic*
cat <<add>> /etc/elasticsearch/elasticsearch.yml
network.host: 192.168.56.111
http.port: 9200
discovery.seed_hosts: ["192.168.56.222"]
add

#sudo sed -i 's/#network.host: localhost/network.host: 192.168.56.111/' /etc/elasticsearch/elasticsearch.yml
#echo discovery.seed_hosts: ["192.168.56.222"] >> /etc/elasticsearch/elasticsearch.yml
#sudo sed -i 's/#http.port: 9200/http.port: 9200/' /etc/elasticsearch/elasticsearch.yml

systemctl daemon-reload
systemctl enable elasticsearch
systemctl start elasticsearch
sudo wget https://artifacts.elastic.co/downloads/kibana/kibana-7.4.0-x86_64.rpm
rpm -ivh kibana*

cat <<add>> /etc/kibana/kibana.yml
server.port: 5601
server.host: 192.168.56.111
elasticsearch.url: "http://192.168.56.111:9200"
add

#sudo sed -i 's/#server.port: 5601/server.port: 5601/' /etc/kibana/kibana.yml
#sudo sed -i 's/#server.host: "localhost"/server.host: 192.168.56.111/' /etc/kibana/kibana.yml
#sudo sed -i 's/elasticsearch.url: "http:\/\/localhost:9200"/elasticsearch.url: "http:\/\/192.168.56.111:9200"/' /etc/kibana/kibana.yml
systemctl enable kibana
systemctl start kibana
