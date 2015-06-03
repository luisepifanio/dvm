#!/usr/bin/env bash

set -e

{ # this ensures the entire script is downloaded #

if [ -z "$DVM_DIR" ]; then
  DVM_DIR="$HOME/.dvm"
fi

nvm_latest_version() {
  echo "v0.0.1"
}

#
# Detect profile file if not specified as environment variable
# (eg: PROFILE=~/.myprofile)
# The echo'ed path is guaranteed to be an existing file
# Otherwise, an empty string is returned
#
dvm_detect_profile() {
  if [ -f "$PROFILE" ]; then
    echo "$PROFILE"
  elif [ -f "$HOME/.bashrc" ]; then
    echo "$HOME/.bashrc"
  elif [ -f "$HOME/.bash_profile" ]; then
    echo "$HOME/.bash_profile"
  elif [ -f "$HOME/.zshrc" ]; then
    echo "$HOME/.zshrc"
  elif [ -f "$HOME/.profile" ]; then
    echo "$HOME/.profile"
  fi
}

install_dvm_from_git() {
  DVM_SOURCE_URL="https://github.com/luisepifanio/dvm.git"
  if [ -d "$DVM_DIR/.git" ]; then
    echo "=> dvm is already installed in $DVM_DIR, trying to update using git"
    printf "\r=> "
    cd "$DVM_DIR" && (command git fetch 2> /dev/null || {
      echo >&2 "Failed to update dvm, run 'git fetch' in $DVM_DIR yourself." && exit 1
    })
  else
    # Cloning to $DVM_DIR
    echo "=> Downloading dvm from git to '$DVM_DIR'"
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

  local DVM_PROFILE
  DVM_PROFILE=$(dvm_detect_profile)

  SOURCE_STR="\nexport DVM_DIR=\"$DVM_DIR\"\n[ -s \"\$DVM_DIR/dvm.sh\" ] && . \"\$DVM_DIR/nvm.sh\"  # This loads nvm"

  if [ -z "$DVM_PROFILE" ] ; then
    echo "=> Profile not found. Tried $NVM_PROFILE (as defined in \$PROFILE), ~/.bashrc, ~/.bash_profile, ~/.zshrc, and ~/.profile."
    echo "=> Create one of them and run this script again"
    echo "=> Create it (touch $NVM_PROFILE) and run this script again"
    echo "   OR"
    echo "=> Append the following lines to the correct file yourself:"
    printf "$SOURCE_STR"
    echo
  else
    if ! grep -qc 'nvm.sh' "$DVM_PROFILE"; then
      echo "=> Appending source string to $DVM_PROFILE"
      printf "$SOURCE_STR\n" >> "$DVM_PROFILE"
    else
      echo "=> Source string already in $DVM_PROFILE"
    fi
  fi

}

[ "_$DVM_ENV" = "_testing" ] || dvm_do_install

} # this ensures the entire script is downloaded #