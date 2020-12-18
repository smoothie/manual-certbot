#!/bin/bash
set -e;

## Start ssh-agent.
echo "starting ssh-agent"
eval `ssh-agent -s`
ssh-add /home/certbot/.ssh/id_rsa

## Upload acme token.
mkdir -p ./.well-known
mkdir -p ./.well-known/acme-challenge
echo $CERTBOT_VALIDATION > ./.well-known/acme-challenge/$CERTBOT_TOKEN
rsync -a --no-group --no-owner ./.well-known/ %SSH_HOST%:%SSH_PUBLIC_DIRECTORY%/.well-known
