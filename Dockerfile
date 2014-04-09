FROM quay.io/aptible/ubuntu:12.04

# Install NGiNX from source
RUN apt-get install -y software-properties-common \
      python-software-properties && \
    add-apt-repository -y ppa:nginx/stable && apt-get update && \
    apt-get -y install nginx && \
    echo "daemon off;" >> /etc/nginx/nginx.conf

# Install Go (necessary for Heartbleed test)
RUN apt-get install -y wget && cd /tmp && \
    wget https://go.googlecode.com/files/go1.2.1.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.2.1.linux-amd64.tar.gz

ADD test /tmp/test
RUN bats /tmp/test

# Uninstall Go
RUN rm -rf /tmp/go1.2.1.linux-amd64.tar.gz /usr/local/go

VOLUME ["/etc/nginx/sites-enabled"]
EXPOSE 80 443

CMD ["/usr/sbin/nginx"]
