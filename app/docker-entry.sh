#!/bin/bash
config=/mattermost/config/config.json

echo -ne "Configure database connection..."
cp /config.template.json $config
sed -Ei "s/DBAAS_MYSQL_ENDPOINT/$DBAAS_MYSQL_ENDPOINT/" $config
echo OK

echo "Starting platform"
cd /mattermost/bin
./platform $*
