# the different stages of this Dockerfile are meant to be built into separate images
# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target

# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG HOST_USER_ID=1000
ARG HOST_GROUP_ID=1000

# "certbot" stage
FROM debian:buster-slim AS CERT_CREATION

## Provide stage arguments.
ARG CERTBOT_DOMAIN
ARG CERTBOT_EMAIL
ARG HOST_GROUP_ID
ARG HOST_USER_ID
ARG SSH_HOST
ARG SSH_HOST_NAME
ARG SSH_PUBLIC_DIRECTORY
ARG SSH_USER

## Update and install dependencies.
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		certbot \
		openssh-server \
		rsync \
		xz-utils \
	; \
	rm -rf /var/lib/apt/lists/*; \
    # Create new user with given UID and GID: `certbot`.
    addgroup --gid $HOST_GROUP_ID certbot; \
    adduser \
        --disabled-password \
        --gecos '' \
        --gid $HOST_GROUP_ID \
        --uid $HOST_USER_ID \
        certbot \
    ;

## Jump to working directory.
WORKDIR /var/certbot/app

## Paste stuff.
COPY . .
COPY config/ssh /home/certbot/.ssh
COPY config/certbot.ini /var/certbot/config/certbot.ini
COPY scripts /var/certbot/scripts
COPY templates/ssh/config /home/certbot/.ssh/config

## Allow certbot to do stuff.
RUN set -eux; \
    chown -R certbot:certbot /home/certbot; \
    chown -R certbot:certbot /home/certbot/.ssh; \
    ## Replace placeholder with stage arguments.
    grep -rl "%CERTBOT_DOMAIN%" /var/certbot/config | xargs --no-run-if-empty sed -in "s|%CERTBOT_DOMAIN%|$CERTBOT_DOMAIN|g"; \
    grep -rl "%CERTBOT_EMAIL%" /var/certbot/config | xargs --no-run-if-empty sed -in "s|%CERTBOT_EMAIL%|$CERTBOT_EMAIL|g"; \
    grep -rl "%HOST_GROUP_ID%" /var/certbot/scripts | xargs --no-run-if-empty sed -in "s|%HOST_GROUP_ID%|$HOST_GROUP_ID|g"; \
    grep -rl "%HOST_USER_ID%" /var/certbot/scripts | xargs --no-run-if-empty sed -in "s|%HOST_USER_ID%|$HOST_USER_ID|g"; \
    grep -rl "%SSH_HOST%" /var/certbot/scripts | xargs --no-run-if-empty sed -in "s|%SSH_HOST%|$SSH_HOST|g"; \
    grep -rl "%SSH_HOST_NAME%" /var/certbot/scripts | xargs --no-run-if-empty sed -in "s|%SSH_HOST_NAME%|$SSH_HOST_NAME|g"; \
    grep -rl "%SSH_PUBLIC_DIRECTORY%" /var/certbot/scripts | xargs --no-run-if-empty sed -in "s|%SSH_PUBLIC_DIRECTORY%|$SSH_PUBLIC_DIRECTORY|g"; \
    sed -in "s|%SSH_HOST%|$SSH_HOST|g" /home/certbot/.ssh/config; \
    sed -in "s|%SSH_HOST_NAME%|$SSH_HOST_NAME|g" /home/certbot/.ssh/config; \
    sed -in "s|%SSH_USER%|$SSH_USER|g" /home/certbot/.ssh/config; \
    ## Prepare executable entrypoint.
    cp /var/certbot/scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint; \
    chmod +x /usr/local/bin/docker-entrypoint;

## Finally, do ya thing.
ENTRYPOINT ["docker-entrypoint"]
