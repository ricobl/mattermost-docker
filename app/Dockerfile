FROM ubuntu:14.04

RUN apt-get update && apt-get -y install curl python-minimal
RUN mkdir -p /mattermost/data

RUN curl https://releases.mattermost.com/3.4.0/mattermost-team-3.4.0-linux-amd64.tar.gz | tar -xvz

RUN rm /mattermost/config/config.json
COPY config.template.json /

COPY docker-entry.sh /
COPY generate-config.py /
RUN chmod +x /docker-entry.sh
ENTRYPOINT ["/docker-entry.sh"]

EXPOSE 80
