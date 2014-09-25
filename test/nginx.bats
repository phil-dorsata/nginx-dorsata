#!/usr/bin/env bats

install-heartbleed() {
  export GOPATH=/tmp/gocode
  export PATH=${PATH}:/usr/local/go/bin:${GOPATH}/bin
  go get github.com/FiloSottile/Heartbleed
  go install github.com/FiloSottile/Heartbleed
}

uninstall-heartbleed() {
  rm -rf ${GOPATH}
}

setup() {
  cp ${BATS_TEST_DIRNAME}/templates/server.conf /etc/nginx/sites-enabled/
  cp ${BATS_TEST_DIRNAME}/templates/server.crt /etc/nginx/ssl/
  cp ${BATS_TEST_DIRNAME}/templates/server.key /etc/nginx/ssl/

  /usr/sbin/nginx &
}

teardown() {
  rm /etc/nginx/sites-enabled/server.conf
  rm /etc/nginx/ssl/server.crt
  rm /etc/nginx/ssl/server.key

  pkill nginx
}

@test "It should install NGiNX 1.6.2" {
  run /usr/sbin/nginx -v
  [[ "$output" =~ "1.6.2"  ]]
}

@test "It should pass an external Heartbleed test" {
  install-heartbleed
  Heartbleed localhost:443
  uninstall-heartbleed
}

@test "It should accept large file uploads" {
  dd if=/dev/zero of=zeros.bin count=1024 bs=4096
  run curl -k --form upload=@zeros.bin --form press=OK https://localhost:443/
  [[ ! "$output" =~ "413"  ]]
}

@test "It should log to STDOUT" {
  pkill nginx
  /usr/sbin/nginx > /tmp/nginx.log &
  curl localhost:80 > /dev/null 2>&1
  [[ -s /tmp/nginx.log ]]
}
