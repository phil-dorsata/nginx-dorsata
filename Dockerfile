FROM quay.io/aptible/ubuntu:12.10

# Install NGiNX from
RUN apt-get install -y software-properties-common && \
      add-apt-repository -y ppa:nginx/stable && apt-get update && \
      apt-get -y install nginx && \
      echo "daemon off;" >> /etc/nginx/nginx.conf

ADD test /tmp/test
RUN bats /tmp/test

VOLUME ["/etc/nginx/sites-enabled"]
EXPOSE 80 443

CMD ["/usr/sbin/nginx"]
