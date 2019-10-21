#!/bin/bash
 IP=192.168.56.222
 HOST_NAME=LinuxVM
 ERROR='0'
 ZABBIX_USER='Admin' 
 ZABBIX_PASS='zabbix' 
 ZABBIX_SERVER='192.168.56.111' 
 API='http://192.168.56.111/api_jsonrpc.php'

curlOutput=`curl -sS -i -X POST -H 'Content-Type: application/json-rpc' -d "{\"params\": {\"password\": \"$ZABBIX_PASS\", \"user\": \"$ZABBIX_USER\"}, \"jsonrpc\":\"2.0\", \"method\": \"user.login\", \"id\": 0}" $API`
AUTH_TOKEN=`echo $curlOutput | sed -n 's/.*result":"\(.*\)",.*/\1/p'`

create_group() {
curl -i -X POST -H 'Content-Type: application/json-rpc' -d "{\"jsonrpc\":\"2.0\",\"method\":\"hostgroup.create\",\"params\":{\"name\":\"CLOUD HOSTS\"},\"auth\":\"$AUTH_TOKEN\",\"id\":0}" $API
}
group=$(create_group)

get_group(){
curl -i -X POST -H 'Content-Type: application/json-rpc' -d "{\"jsonrpc\":\"2.0\",\"method\":\"hostgroup.get\",\"params\":{\"output\":\"extend\",\"filter\":{\"name\":[\"CLOUD HOSTS\"]}},\"auth\":\"$AUTH_TOKEN\",\"id\":0}" $API
}
gid=$(get_group)
HOSTGROUPID=`echo $gid | cut -d '"' -f 10 `

get_template(){
curl -i -X POST -H 'Content-Type: application/json-rpc' -d "{\"jsonrpc\":\"2.0\",\"method\":\"template.get\",\"params\":{\"output\":\"extend\",\"filter\":{\"host\":[\"Template OS Linux by Zabbix agent\"]}},\"auth\":\"$AUTH_TOKEN\",\"id\":0}" $API
}
tid=$(get_template)
TEMPLATEID=`echo $tid | cut -d '"' -f 130 `

create_host() {
  curl -i -X POST -H 'Content-Type: application/json-rpc' -d "{\"jsonrpc\":\"2.0\",\"method\":\"host.create\",\"params\":{\"host\":\"$HOST_NAME\",\"interfaces\":[{\"type\":1,\"main\":1,\"useip\":1,\"ip\":\"$IP\",\"dns\":\"$HOST_NAME\",\"port\":10050}],\"groups\":[{\"groupid\":$HOSTGROUPID}],\"templates\":[{\"templateid\":$TEMPLATEID}]},\"auth\":\"$AUTH_TOKEN\",\"id\":0}" $API
}
output=$(create_host)

echo $output | grep -q "hostids"
rc=$?
if [ $rc -ne 0 ]
 then
        echo -e "Error in adding host ${HOST_NAME} at `date`:\n"
        exit
else
        echo -e "\nHost ${HOST_NAME} added successfully, starting Zabbix Agent\n"
        service zabbix-agent start
        exit
fi

