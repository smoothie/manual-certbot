#!/bin/bash
set -e;

## Create persistent directories.
mkdir -p /var/certbot/app/working
mkdir -p /var/certbot/app/config
mkdir -p /var/certbot/app/logs

## More SSH related preparations.
cat /home/certbot/.ssh/config >> /etc/ssh/ssh_config
touch /home/certbot/.ssh/known_hosts

chown -R %HOST_USER_ID%:%HOST_GROUP_ID% /var/certbot/app

chmod 644 /home/certbot/.ssh/known_hosts
chmod 700 /home/certbot/.ssh
chmod 644 /home/certbot/.ssh/config
chmod 600 /home/certbot/.ssh/id_rsa

## Host to known hosts.
eval `ssh-agent -s`
ssh-keyscan %SSH_HOST_NAME% >> /home/certbot/.ssh/known_hosts

## Run certbot as certbot.
su certbot --group certbot --command "certbot certonly --manual --config=/var/certbot/config/certbot.ini --non-interactive"
## To debug switch the above with the below.
#su certbot --group certbot --command "certbot certonly --manual --config=/var/certbot/config/certbot.ini --non-interactive --dry-run"

## Fix permissions.
chown -R %HOST_USER_ID%:%HOST_GROUP_ID% /var/certbot/app
