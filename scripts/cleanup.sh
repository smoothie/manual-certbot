#!/bin/bash
set -e;

## Start ssh-agent.
eval `ssh-agent -s`
ssh-add /home/certbot/.ssh/id_rsa

## Delete acme stuff.
ssh %SSH_HOST% "rm -rf %SSH_PUBLIC_DIRECTORY%/.well-known/"
rm -rf ./.well-known/
