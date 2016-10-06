#!/bin/bash

config=/mattermost/config/config.json
NO_PROTOCOL_DBAAS_MYSQL_ENDPOINT=`echo $DBAAS_MYSQL_ENDPOINT | sed -e 's#mysql://##'`

echo -ne "Configure database connection..."
cp /config.template.json $config
sed -i -e "s#DBAAS_MYSQL_ENDPOINT#$NO_PROTOCOL_DBAAS_MYSQL_ENDPOINT#" $config
echo OK

echo "Starting platform"
cd /mattermost/bin
./platform $*
