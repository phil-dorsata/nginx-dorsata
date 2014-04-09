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

@test "It should install NGiNX 1.4.7" {
  run /usr/sbin/nginx -v
  [[ "$output" =~ "1.4.7"  ]]
}

@test "It should pass an external Heartbleed test" {
  /usr/sbin/nginx -c ${BATS_TEST_DIRNAME}/templates/nginx.conf &
  install-heartbleed
  Heartbleed localhost:443
  uninstall-heartbleed
  pkill nginx
}
