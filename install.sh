#!/usr/bin/env bash

set -e

{ # this ensures the entire script is downloaded #

if [ -z "$DVM_DIR" ]; then
  DVM_DIR="$HOME/.dvm"
fi

nvm_latest_version() {
  echo "v0.0.1"
}

install_dvm_from_git() {
  DVM_SOURCE_URL="https://github.com/luisepifanio/dvm.git"
  if [ -d "$DVM_DIR/.git" ]; then
    echo "=> dvm is already installed in $DVM_DIR, trying to update using git"
    printf "\r=> "
    cd "$DVM_DIR" && (command git fetch 2> /dev/null || {
      echo >&2 "Failed to update nvm, run 'git fetch' in $DVM_DIR yourself." && exit 1
    })
  else
    # Cloning to $DVM_DIR
    echo "=> Downloading nvm from git to '$DVM_DIR'"
    printf "\r=> "
    mkdir -p "$DVM_DIR"
    command git clone "$DVM_SOURCE_URL" "$DVM_DIR"
  fi
  #cd "$DVM_DIR" && command git checkout --quiet $(dvm_latest_version)
  if [ ! -z "$(cd "$DVM_DIR" && git show-ref refs/heads/master)" ]; then
    if git branch --quiet 2>/dev/null; then
      cd "$DVM_DIR" && command git branch --quiet -D master >/dev/null 2>&1
    else
      echo >&2 "Your version of git is out of date. Please update it!"
      cd "$DVM_DIR" && command git branch -D master >/dev/null 2>&1
    fi
  fi
  return
}

dvm_do_install(){
  install_dvm_from_git
}

[ "_$DVM_ENV" = "_testing" ] || dvm_do_install

} # this ensures the entire script is downloaded #