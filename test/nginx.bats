#!/usr/bin/env bats

@test "It should install NGiNX 1.4.6" {
  run /usr/sbin/nginx -v
  [[ "$output" =~ "1.4.6"  ]]
}
