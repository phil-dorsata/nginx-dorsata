FROM quay.io/aptible/alpine

# ruby necessary for ERB
# curl necessary for integration tests
RUN apk-install ruby curl

ADD install-nginx /tmp/
RUN /tmp/install-nginx

# Generate a 2048-bit Diffie-Hellman group in line with recommendations
# at https://weakdh.org/sysadmin.html.
RUN openssl dhparam -out /etc/nginx/dhparams.pem 2048

ADD templates/etc /etc
ADD templates/bin /usr/local/bin


VOLUME /etc/nginx/ssl

EXPOSE 80 443

CMD ["/usr/local/bin/nginx-wrapper"]
