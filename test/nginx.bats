#!/usr/bin/env bats

install_heartbleed() {
  export GOPATH=/tmp/gocode
  export PATH=${PATH}:/usr/local/go/bin:${GOPATH}/bin
  go get github.com/FiloSottile/Heartbleed
  go install github.com/FiloSottile/Heartbleed
}

uninstall_heartbleed() {
  rm -rf ${GOPATH}
}

wait_for_nginx() {
  /usr/local/bin/nginx-wrapper > /tmp/nginx.log &
  while ! pgrep -x nginx > /dev/null ; do sleep 0.1; done
}

simulate_upstream() {
  # `sleep 0.5` is necessary to avoid the following NGiNX error:
  # readv() failed (104: Connection reset by peer) while reading upstream
  cmd="cat ${BATS_TEST_DIRNAME}/upstream-response.txt && sleep 0.5"
  tcpserver localhost 4000 sh -c "$cmd" &
}

teardown() {
  pkill nginx-wrapper || true
  pkill nginx || true
  pkill tcpserver || true
  rm -rf /etc/nginx/ssl/*
}

@test "It should install NGiNX 1.6.2" {
  run /usr/sbin/nginx -v
  [[ "$output" =~ "1.6.2"  ]]
}

@test "It should pass an external Heartbleed test" {
  install_heartbleed
  wait_for_nginx
  Heartbleed localhost:443
  uninstall_heartbleed
}

@test "It should accept large file uploads" {
  dd if=/dev/zero of=zeros.bin count=1024 bs=4096
  wait_for_nginx
  run curl -k --form upload=@zeros.bin --form press=OK https://localhost:443/
  [[ ! "$output" =~ "413"  ]]
}

@test "It should log to STDOUT" {
  wait_for_nginx
  curl localhost > /dev/null 2>&1
  [[ -s /tmp/nginx.log ]]
}

@test "It should accept and configure a MAINTENANCE_PAGE_URL" {
  skip
}

@test "It should accept a list of UPSTREAM_SERVERS" {
  simulate_upstream
  UPSTREAM_SERVERS=localhost:4000 wait_for_nginx
  run curl localhost 2>/dev/null
  [[ "$output" =~ "Hello World!" ]]
}

@test "It should honor FORCE_SSL" {
  FORCE_SSL=true wait_for_nginx
  run curl -I localhost 2>/dev/null
  [[ "$output" =~ "HTTP/1.1 301 Moved Permanently" ]]
  [[ "$output" =~ "Location: https://localhost" ]]
}
