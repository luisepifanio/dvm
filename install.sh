#!/usr/bin/env sh

set -e

{ # this ensures the entire script is downloaded #

dvm_has() {
  type "$1" > /dev/null 2>&1
}

if [ -z "$DVM_DIR" ]; then
  DVM_DIR="$HOME/.dvm"
fi

dvm_latest_version() {
  echo "0.0.4"
}

#
# Outputs the location to DVM depending on:
# * The availability of $DVM_SOURCE
# * The method used ("script" or "git" in the script, defaults to "git")
# DVM_SOURCE always takes precedence unless the method is "script-dvm-exec"
#
dvm_source() {
  local DVM_METHOD
  DVM_METHOD="$1"
  local DVM_SOURCE_URL
  DVM_SOURCE_URL="$DVM_SOURCE"
  if [ "_$DVM_METHOD" = "_script-dvm-exec" ]; then
    DVM_SOURCE_URL="https://raw.githubusercontent.com/luisepifanio/dvm/$(dvm_latest_version)/dvm-exec"
  elif [ -z "$DVM_SOURCE_URL" ]; then
    if [ "_$DVM_METHOD" = "_script" ]; then
      DVM_SOURCE_URL="https://raw.githubusercontent.com/luisepifanio/dvm/$(dvm_latest_version)/dvm.sh"
    elif [ "_$DVM_METHOD" = "_git" ] || [ -z "$DVM_METHOD" ]; then
      DVM_SOURCE_URL="https://github.com/luisepifanio/dvm.git"
    else
      echo >&2 "Unexpected value \"$DVM_METHOD\" for \$DVM_METHOD"
      return 1
    fi
  fi
  echo "$DVM_SOURCE_URL"
}

dvm_download() {
  if dvm_has "curl"; then
    curl -q $*
  elif dvm_has "wget"; then
    # Emulate curl with wget
    ARGS=$(echo "$*" | command sed -e 's/--progress-bar /--progress=bar /' \
                           -e 's/-L //' \
                           -e 's/-I /--server-response /' \
                           -e 's/-s /-q /' \
                           -e 's/-o /-O /' \
                           -e 's/-C - /-c /')
    wget $ARGS
  fi
}

install_dvm_from_git() {
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
    command git clone "$(dvm_source git)" "$DVM_DIR"
  fi
  cd "$DVM_DIR" && command git checkout --quiet $(dvm_latest_version)
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

install_dvm_as_script() {
  local DVM_SOURCE_LOCAL
  DVM_SOURCE_LOCAL=$(dvm_source script)
  local DVM_EXEC_SOURCE
  DVM_EXEC_SOURCE=$(dvm_source script-dvm-exec)

  # Downloading to $DVM_DIR
  mkdir -p "$DVM_DIR"
  if [ -d "$DVM_DIR/dvm.sh" ]; then
    echo "=> dvm is already installed in $DVM_DIR, trying to update the script"
  else
    echo "=> Downloading dvm as script to '$DVM_DIR'"
  fi
  dvm_download -s "$DVM_SOURCE_LOCAL" -o "$DVM_DIR/dvm.sh" || {
    echo >&2 "Failed to download '$DVM_SOURCE_LOCAL'"
    return 1
  }
  dvm_download -s "$DVM_EXEC_SOURCE" -o "$DVM_DIR/dvm-exec" || {
    echo >&2 "Failed to download '$DVM_EXEC_SOURCE'"
    return 2
  }
  chmod a+x "$DVM_DIR/dvm-exec" || {
    echo >&2 "Failed to mark '$DVM_DIR/dvm-exec' as executable"
    return 3
  }
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

#
# Check whether the user has any globally-installed npm modules in their system
# Node, and warn them if so.
#
dvm_check_global_modules() {
  command -v npm >/dev/null 2>&1 || return 0

  local NPM_VERSION
  NPM_VERSION="$(npm --version)"
  NPM_VERSION="${NPM_VERSION:--1}"
  [ "${NPM_VERSION%%[!-0-9]*}" -gt 0 ] || return 0

  local NPM_GLOBAL_MODULES
  NPM_GLOBAL_MODULES="$(
    npm list -g --depth=0 |
    sed '/ npm@/d' |
    sed '/ (empty)$/d'
  )"

  local MODULE_COUNT
  MODULE_COUNT="$(
    printf %s\\n "$NPM_GLOBAL_MODULES" |
    sed -ne '1!p' |                             # Remove the first line
    wc -l | tr -d ' '                           # Count entries
  )"

  if [ $MODULE_COUNT -ne 0 ]; then
    cat <<-'END_MESSAGE'
	=> You currently have modules installed globally with `npm`. These will no
	=> longer be linked to the active version of Node when you install a new node
	=> with `dvm`; and they may (depending on how you construct your `$PATH`)
	=> override the binaries of modules installed with `dvm`:

	END_MESSAGE
    printf %s\\n "$NPM_GLOBAL_MODULES"
    cat <<-'END_MESSAGE'

	=> If you wish to uninstall them at a later point (or re-install them under your
	=> `dvm` Nodes), you can remove them from the system Node as follows:

	     $ dvm use system
	     $ npm uninstall -g a_module

	END_MESSAGE
  fi
}

dvm_do_install() {
  if [ -z "$METHOD" ]; then
    # Autodetect install method
    if dvm_has "git"; then
      install_dvm_from_git
    elif dvm_has "dvm_download"; then
      install_dvm_as_script
    else
      echo >&2 "You need git, curl, or wget to install dvm"
      exit 1
    fi
  elif [ "~$METHOD" = "~git" ]; then
    if ! dvm_has "git"; then
      echo >&2 "You need git to install dvm"
      exit 1
    fi
    install_dvm_from_git
  elif [ "~$METHOD" = "~script" ]; then
    if ! dvm_has "dvm_download"; then
      echo >&2 "You need curl or wget to install dvm"
      exit 1
    fi
    install_dvm_as_script
  fi

  local DVM_PROFILE
  DVM_PROFILE=$(dvm_detect_profile)

  echo "=> Profile detected on $DVM_PROFILE"

  SOURCE_STR="\nexport DVM_DIR=\"$DVM_DIR\"\n[ -s \"\$DVM_DIR/dvm.sh\" ] && . \"\$DVM_DIR/dvm.sh\"  # This loads dvm"

  if [ -z "$DVM_PROFILE" ] ; then
    echo "=> Profile not found. Tried $DVM_PROFILE (as defined in \$PROFILE), ~/.bashrc, ~/.bash_profile, ~/.zshrc, and ~/.profile."
    echo "=> Create one of them and run this script again"
    echo "=> Create it (touch $DVM_PROFILE) and run this script again"
    echo "   OR"
    echo "=> Append the following lines to the correct file yourself:"
    printf "$SOURCE_STR"
    echo
  else
    if ! grep -qc 'dvm.sh' "$DVM_PROFILE"; then
      echo "=> Appending source string to $DVM_PROFILE"
      printf "$SOURCE_STR\n" >> "$DVM_PROFILE"
    else
      echo "=> Source string already in $DVM_PROFILE"
    fi
  fi

  echo "=> Close and reopen your terminal to start using dvm"
  dvm_reset
}

#
# Unsets the various functions defined
# during the execution of the install script
#
dvm_reset() {
  unset -f dvm_reset dvm_has dvm_latest_version \
    dvm_source dvm_download install_dvm_as_script install_dvm_from_git \
    dvm_detect_profile dvm_do_install
}

[ "_$DVM_ENV" = "_testing" ] || dvm_do_install

} # this ensures the entire script is downloaded #
