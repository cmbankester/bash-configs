#!/usr/bin/env bash

update_remotes ()
{
  if [[ "$#" -gt 0 ]]; then
    if [[ "$1" = "--check" ]]; then
      local has_updates=""
      if [[ "$#" -gt 1 ]]; then
        shift
        for remote in "$@"; do
          if _check_remote $remote; then
            has_updates+=" $remote"
          fi 
        done
        if [[ ! "$has_updates" = "" ]]; then
          printf "%s%s\n" "UPDATES AVAILABLE FOR:" "$has_updates"
        fi
      fi
    else
      for remote in "$@"; do
        _update_remote $remote
      done
    fi
  fi
}

_update_remote ()
{
  printf "%s\n" "Updating packages for $1..."
  printf "%s\n" "> ssh $1 sudo yum update -y"
  printf "%s\n" "--------OUTPUT:--------"

  ssh "$1" sudo yum update -y
}

_check_remote ()
{
  printf "%s\n" "Checking $1 for updates..."
  printf "%s\n" "> ssh $1 sudo yum -q check-update"

  local output="$(ssh "$1" sudo yum -q check-update)"
  if [[ ! "$output" = "" ]]; then
    printf "%s%s\n\n" "--------UPDATES:--------" "$output"
    return 0
  else
    printf "%s\n\n" "-------NO UPDATES-------"
    return 1
  fi
}
