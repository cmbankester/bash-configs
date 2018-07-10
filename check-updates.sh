#!/usr/bin/env sh

update-remotes ()
{
  if [[ "$#" -gt 0 ]]; then
    if [[ "$1" = "--check" ]]; then
      local has_updates=""
      if [[ "$#" -gt 1 ]]; then
        shift
        for remote in "$@"; do
          _check-remote $remote && (
            has_updates="${has_updates} $remote"
          )
        done
        if [[ ! "$has_updates" = "" ]];
          printf "UPDATES AVAILABLE FOR: %s" "$has_updates"
        fi
      fi
    else
      for remote in "$@"; do
        _update-remote $remote
      done
    fi
  fi
}

_update-remote ()
{
  printf "Updating packages for %s...\n" "$1"
  printf "> ssh %s sudo yum update -y\n" "$1"
  printf "--------OUTPUT:--------\n"

  ssh "$1" sudo yum update -y
}

_check-remote ()
{
  printf "Checking %s for updates...\n" $servername
  printf "> ssh %s sudo yum -q check-update\n" $servername

  local output="$(ssh $servername sudo yum -q check-update)"
  if [[ ! "$output" = "" ]]; then
    printf "--------UPDATES:--------%s\n" $output
    return 0
  else
    printf "-------NO UPDATES-------\n\n"
    return 1
  fi
}
