#!/usr/bin/bats

@test "check if port 443 is listening" {
  run lsof -i:443|awk '{ print $9}'
  [[ $outout = '*:https' ]]
}
