FROM quay.io/aptible/alpine

# ruby necessary for ERB
# curl necessary for integration tests
RUN apk-install ruby=2.1.5-r1 curl

ADD install-nginx /tmp/
RUN /tmp/install-nginx

# TODO: heartbleed test?

ADD templates/etc /etc
ADD templates/bin /usr/local/bin

ADD test /tmp/test
# haproxy necessary for Proxy Protocol integration tests
# haproxy 1.5 is not in the mainline alpine repository as of this writing (Feb 15, 2015).
# cf. http://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management#Add_a_Package
RUN apk-install haproxy=1.5.11-r0 --repository http://dl-4.alpinelinux.org/alpine/edge/main \
	&& bats /tmp/test \
	&& rm -rf /tmp/nginx/* \
	&& apk del haproxy

VOLUME /etc/nginx/ssl

EXPOSE 80 443

CMD ["/usr/local/bin/nginx-wrapper"]
