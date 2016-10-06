#!/bin/bash
config=/mattermost/config/config.json

echo -ne "Configure database connection..."
cp /config.template.json $config
sed -Ei "s/DBAAS_MYSQL_ENDPOINT/$DBAAS_MYSQL_ENDPOINT/" $config
echo OK

echo "Wait until database $DB_HOST:$DB_PORT_5432_TCP_PORT is ready..."
until nc -z $DB_HOST $DB_PORT_5432_TCP_PORT
do
    sleep 1
done

# Wait to avoid "panic: Failed to open sql connection pq: the database system is starting up"
sleep 1

echo "Starting platform"
cd /mattermost/bin
./platform $*
