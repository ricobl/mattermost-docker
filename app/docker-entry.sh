#!/bin/bash

config=/mattermost/config/config.json

echo -ne "Generating config file from environment variables... "
python generate-config.py /config.template.json $config
echo OK

echo "Starting platform"
cd /mattermost/bin
./platform $*
