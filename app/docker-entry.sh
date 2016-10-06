#!/bin/bash

config=/mattermost/config/config.json

_parse_endpoint() {
    endpoint=$1
    # Remove protocol
    endpoint=$(echo $endpoint | sed -e 's#mysql://##')
    # Wrap domain in @tcp()
    endpoint=$(echo $endpoint | sed -e 's#@\([^/]*\)/#@tcp(\1)/#')
    echo $endpoint
}

PARSED_DBAAS_MYSQL_ENDPOINT=`_parse_endpoint $DBAAS_MYSQL_ENDPOINT`

echo -ne "Configure database connection..."
cp /config.template.json $config

sed -i -e "s#DBAAS_MYSQL_ENDPOINT#$PARSED_DBAAS_MYSQL_ENDPOINT#" $config
sed -i -e "s#APP_PORT#$PORT#" $config
sed -i -e "s#SMTP_SERVER#$SMTP_SERVER#" $config
sed -i -e "s#RESTRICT_CREATION_TO_DOMAINS#$RESTRICT_CREATION_TO_DOMAINS#" $config

echo OK

echo "Starting platform"
cd /mattermost/bin
./platform $*
