# ![](https://gravatar.com/avatar/11d3bc4c3163e3d238d558d5c9d98efe?s=64) aptible/nginx

[![Docker Repository on Quay.io](https://quay.io/repository/aptible/nginx/status)](https://quay.io/repository/aptible/nginx)

NGiNX HTTP reverse proxy server.

## Installation and Usage

    docker pull quay.io/aptible/nginx
    docker run -P quay.io/aptible/nginx

To proxy to an upstream host(s) and port(s), set the `UPSTREAM_SERVERS` environment variable:

    docker run -P -e UPSTREAM_SERVERS=host1:3000,host2:4000 quay.io/aptible/nginx

The server starts with a default self-signed certificate. To load in your own certificate and private key, pass them in as mounted Docker "volumes." For example:

    docker run -v /path/to/server.key:/etc/nginx/ssl/server.key -v /path/to/server.crt:/etc/nginx/ssl/server.crt quay.io/aptible/nginx

To force SSL, set the `FORCE_SSL` environment variable to `true`:

    docker run -e FORCE_SSL=true quay.io/aptible/nginx

### Simulating trusted SSL connections

If you're on OS X running boot2docker, you can configure your system to trust NGiNX's self-signed certificate by taking the following steps:

1. Add an entry to your /etc/hosts file mapping your Docker IP address:

        sudo echo $(boot2docker ip 2>/dev/null) example.com >> /etc/hosts

1. Start your NGiNX container (daemonized), and copy the automatically-generated certificate to your desktop.

        ID=$(docker run -d -p 80:80 -p 443:443 quay.io/aptible/nginx)
        docker cp ${ID}:/etc/nginx/ssl/server.crt /tmp/
        open /tmp/server.crt

1. Choose to "always trust" it within Keychain.

1. Visit https://example.com and see the trusted certificate.


## Available Tags

* `latest`: Currently NGiNX 1.6.2

## Deployment

To push the Docker image to Quay, run the following command:

    make release

## Copyright and License

MIT License, see [LICENSE](LICENSE.md) for details.

Copyright (c) 2014 [Aptible](https://www.aptible.com) and contributors.

[<img src="https://s.gravatar.com/avatar/f7790b867ae619ae0496460aa28c5861?s=60" style="border-radius: 50%;" alt="@fancyremarker" />](https://github.com/fancyremarker)
