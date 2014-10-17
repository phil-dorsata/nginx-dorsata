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

## Available Tags

* `latest`: Currently NGiNX 1.6.2

## Deployment

To push the Docker image to Quay, run the following command:

    make release

## Copyright and License

MIT License, see [LICENSE](LICENSE.md) for details.

Copyright (c) 2014 [Aptible](https://www.aptible.com), [Frank Macreery](https://github.com/fancyremarker), and contributors.
