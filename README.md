# smoothie Certbot

A docker-compose setup to handle manual authenticated certbot certificates.

## Table Of Contents

* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Arguments](#arguments)
* [Commands](#commands)
* [Thanks And External Resources](#thanks-and-external-resources)
* [Feature Wishlist](#feature-wishlist)
* [Security](#security)
* [License](#license)
* [Contributing](#contributing)

## Requirements

- Target server which supports `rsync`.
- A private key which has SSH access to the target server.
- And argument [details](#arguments).

## Installation

The best way to use this package is through git:

```BASH
git clone github.com:smoothie/manual-certbot.git
```

### Preparation

Before we start we need three things:

- Copy over the `templates/docker-compose.overrideyaml` and paste it `./docker-composer.override.yaml`.
- Change those arguments to match your setup.
- Place the private SSH key into `./config/ssh/id_rsa`.

## Usage

Start the container (e.g.`start.sh`).

It will create a directory: `./.data`. In there you'll find a usual certbot output (`config`, `log`, `working` directories). 

Please remember to make a backup of that directory. 

Once done, proceed with setting up SSL on your server.

## Arguments

| Argument                  | Required   | Description                                                           |
| ------------------------- |:----------:| --------------------------------------------------------------------- |
| `CERTBOT_DOMAIN`          | yes        | Domain which should use the new SSL certificate.                      |
| `CERTBOT_EMAIL`           | yes        | Mail address used for the SSL certificate.                            |
| `SSH_HOST`                | yes        | Providers host. Under the hood used for SSH config.                   |
| `SSH_HOST_NAME`           | yes        | Host name of the provider. Check your host's credentials for details. |
| `SSH_PUBLIC_DIRECTORY`    | yes        | Sites public directory on the server.                                 |
| `SSH_USER`                | yes        | User name provided by the host.                                       |
| `HOST_GROUP_ID`           | no         | Used to set permissions on `.data`. Default: `1000`.                  |
| `HOST_USER_ID`            | no         | Used to set permissions on `.data`. Default: `1000`.                  |

### Placeholders

Under the hood arguments are replaced by placeholders.

A placeholder is an argument wrapped with `%`. For example `%CERTBOT_EMAIL%`.

## Commands

To make lives easier manual-certbot-docker provides a couple of commands for working with `docker-compose`.

| File          | Description   |
| ------------- |---------------|
| `down.sh`     | Stop container, services, volumes and images. |
| `refresh.sh`  | Runs `trash.sh` and `start.sh`.               |
| `start.sh`    | Build container, services.                    |
| `trash.sh`    | Delete container, services and images.        |

## Thanks And External Resources

- [cerbot](https://certbot.eff.org/docs/man/certbot.html)
- [letsencrypt](https://letsencrypt.org/)

## Feature Wishlist

- Iterate the private key handling. Maybe using it as secret. :thinking_face:
- Find a better way to provide volumes with correct permissions.
- Support for multiple domains.

Feel invited to contribute.

## Security

If you discover any security related issues, consider sending me an email to `this[AT]marceichenseher.de` instead of using the issue tracker.

## License

Copyright (c) 2020 Marc Eichenseher

Good news, this plugin is free for everyone! Since it's released under the [MIT](LICENSE) you can use it free of charge on your personal or commercial project.

## Contributing

All feedback / bug reports / pull requests are welcome.
