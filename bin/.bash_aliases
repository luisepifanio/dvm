#!/usr/bin/env sh
#remote ssh common
#alias dynamic_proxy='ssh -D 3100 $USER@$HOST'
#alias map_internal='ssh -L $LOCAL_PORT:$TARGET:$TARGET_PORT $USER@$SSH_HOST'
alias checknode='echo "Node.js: $(node -v)" && echo "Npm Version: $(npm -v)" '
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -laptr' #oldest first sort
alias labc='ls -lap' #alphabetical sort
alias listFiles='ls . | xargs -n 1 basename'
alias svim='sudo vim'
alias grep='grep --color=auto'
# I find typing 'cd ..' less than optimal
alias up='cd ..'
alias 2up='cd ../../'
alias 3up='cd ../../../'
alias 4up='cd ../../../../'
# interactive
alias cp='cp -vi'
alias mv='mv -vi'
alias ping='ping -c 10'
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'
#alias rm='mkdir -p $HOME/.Trash/ && mv --target-directory=$HOME/.Trash/'
alias mkdir='mkdir -pv'
#CDargs should be enabled
alias savedir='ca'
alias goto='cdb'
# DISK USAGE
alias lspart='sudo lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL'
alias showpart='sudo fdisk -l'
alias most='du -hsx * | sort -rn | head -10'
alias df='df -H'
alias du='du -ch'
alias ducks='du -cks * | sort -rn | head'
# PROCESS RELATED
alias ports='netstat -tulanp'
# check if a particular process is running
alias p='ps -ef | egrep -v "grep --color=auto | egrep --color" | egrep --color'
alias diff='colordiff'
# become root #
alias root='sudo -i' #root='sudo su'
alias su='sudo -i'
# reboot / halt / poweroff
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'
#################
alias gcleanbuild='grails clean  && grails test-app :unit --non-interactive'
alias prettyjson='python -m json.tool'
alias clearctrlchars='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
#####################
### SCM FUNCTIONS ###
#####################
alias glg='git log --date-order --all --graph --format="%C(green)%h%Creset %C(yellow)%an%Creset %C(blue bold)%ar%Creset %C(red bold)%d%Creset%s"'
alias glg2='git log --date-order --all --graph --name-status --format="%C(green)%H%Creset %C(yellow)%an%Creset %C(blue bold)%ar%Creset %C(red bold)%d%Creset%s"'
alias cleangitmergedbranches='git branch --merged | grep -v develop | grep -v master | sed -e "s|  ||g" | while read ln; do git branch -d "$ln" ; done'
# hace pull desde el branch en el cual estoy parado, siempre desde origin
gitpull () {
  BRANCH=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/')
  git pull origin "$BRANCH"
}

# hace push al branch en el cual estoy parado, siempre en origin
gitpush () {
  BRANCH=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/')
  git push origin "$BRANCH"
}

#################
### FUNCTIONS ###
#################
ff () {
  find . -name "$@" -print;
}
# Handy Extract Program.
extract () {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xvjf "$1"    ;;
      *.tar.gz)    tar xvzf "$1"    ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xvf "$1"     ;;
      *.tbz2)      tar xvjf "$1"    ;;
      *.tgz)       tar xvzf "$1"    ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "✖ '$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
#Handy compress Program
compress () {
  tar -cvzf "$1" "$2"
}

serverOn () {
  #^-?[0-9]+([.][0-9]+)?$
  re='^[0-9]+$'
  if ! ( echo "$1" | grep -Eq "$re" ) ; then
    echo "✖ Specified port is NOT a number" >&2;
    return 1
  fi

  if [ "$1" -lt 1024 ]; then
    echo "✖ You cannot run server on port below 1024" >&2;
    return 1
  fi

  python -m SimpleHTTPServer "$1"
}

pidOnPort () {
  re='^[0-9]+$'
  if ! ( echo "$1" | grep -Eq "$re" ) ; then
    echo "✖ Specified port is NOT a number" >&2;
    return 1
  fi

  protocols="tcp udp"

  for proto in $protocols
  do
    echo "$( lsof -i $proto:$1 )"
  done
}

psgrep () {
  if [ ! -z "$1" ] ; then
    echo "Grepping for processes matching '$1' "
    ps aux | grep "$1"  | grep -v grep
  else
    echo "✖ Need name to grep for!!"
  fi
}

reloadEnv () {
  unset check_groovy_proxy
  unset check_installed
  unset chownThisFolder
  unset coloredecho
  unset coloredprintf
  unset compress
  unset disable_proxy
  unset enable_proxy
  unset extract
  unset ff
  unset gitpull
  unset gitpush
  unset grails_opts
  unset grails_opts_clean
  unset grails_opts_test
  unset has_installed
  unset ignore
  unset java_opts_clean
  unset java_opts_ivy_logger
  unset lls
  unset mypublicip
  unset pidOnPort
  unset portcheck
  unset psgrep
  unset reloadEnv
  unset serverOn
  unset setupcolor
  unset swapfiles

  if [ -f "$PROFILE" ]; then
    . "$PROFILE"
  elif [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  elif [ -f "$HOME/.bash_profile" ]; then
    . "$HOME/.bash_profile"
  elif [ -f "$HOME/.zshrc" ]; then
    . "$HOME/.zshrc"
  elif [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
  else
    echo "✖ No initializer found"
  fi

  # remove duplicate path entries
  export PATH=$(echo $PATH | awk -F: '
  { for (i = 1; i <= NF; i++) arr[$i]; }
  END { for (i in arr) printf "%s:" , i; printf "\n"; } ')

}

ignore () {
  echo "$1"  >> .gitignore
}

enable_proxy () {
  re='^[0-9]+$'

  if ! ( echo "$HTTP_PROXY_PORT" | grep -Eq "$re" ) ; then
    echo "✖ Proxy port is not a number: '$1' ed" >&2; return 1
  fi

  if [ -z "$HTTP_PROXY_HOST" ]; then
    echo "✖ '$HTTP_PROXY_HOST' is not a valid host" >&2; return 1
  fi

  export http_proxy="$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"

  if ! ( echo "$HTTPS_PROXY_PORT" | grep -Eq "$re" ) ; then
    export HTTPS_PROXY_PORT="$HTTP_PROXY_PORT"
  fi

  if [ -z "$HTTPS_PROXY_HOST" ]; then
    export HTTPS_PROXY_HOST="$HTTP_PROXY_HOST"
  fi

  export https_proxy="$HTTPS_PROXY_HOST:$HTTPS_PROXY_PORT"
}

disable_proxy () {
  export https_proxy=""
  export http_proxy=""

}

chownThisFolder () {
  folder="$1"
  if [ -z "$folder" ]; then
    folder="*"
  fi
  sudo chown -R "$USER:$(id -g -n $USER)" "$folder"
}

grails_opts () {
  if [ -z "$1" ]; then
    echo "'$1' is not a valid config" >&2; return 0
  fi

  GOPTS="-XX:PermSize=$1 -XX:MaxPermSize=$1 -Xmx$1 -Xms$1"
  GOPTS="$GOPTS -XX:+UseParallelGC -XX:+UseParallelOldGC -server -noverify -Xshare:off -Djava.awt.headless=true"
  GOPTS="$GOPTS -Djava.net.preferIPv4Stack=true -XX:+EliminateLocks -XX:+UseBiasedLocking"
  export GRAILS_OPTS="$GOPTS"

  echo "✔ Set up for GRAILS_OPTS=$GRAILS_OPTS"
}

grails_opts_clean () {
  export GRAILS_OPTS=""
  echo "✔ Set up for GRAILS_OPTS=$GRAILS_OPTS"
}

java_opts_clean () {
  export JAVA_OPTS=""
  echo "✔ Set up for JAVA_OPTS=$JAVA_OPTS"
}

java_opts_ivy_logger () {
  export JAVA_OPTS="-Dgroovy.grape.report.downloads=true -Divy.message.logger.level=4"
  echo "✔ Set up for JAVA_OPTS=$JAVA_OPTS"
}

grails_opts_test () {
  grails_opts "3G"
}

check_groovy_proxy () {
  groovy -Dhttp.proxyHost="$HTTP_PROXY_HOST" -Dhttp.proxyPort="$HTTP_PROXY_PORT" -Dhttps.proxyHost="$HTTPS_PROXY_HOST" -Dhttps.proxyPort="$HTTPS_PROXY_PORT"  -e 'try{ println "http://ifconfig.me/ip".toURL().text }catch(Exception e){ println "CHECK NETWORK|PROXY!" }'
}

lls () {
  folder="$1"
  if [ -z "$folder" ]; then
    folder="*"
  fi

  echo "$( stat -c '%A (%a) %8s %.19y %n' $folder )"
}
#########
#netinfo - shows network information for your system

mypublicip () {
  myip=$( dig +short myip.opendns.com @resolver1.opendns.com )
  echo "${myip}"
}


swapfiles () {
  # Swap 2 filenames around, if they exist (from Uzi's bashrc).
  TMPFILE=tmp.$$

  [ $# -ne 2  ] && echo "swap: 2 arguments needed" && return 1
  [ ! -e "$1" ] && echo "swap: $1 does not exist" && return 1
  [ ! -e "$2" ] && echo "swap: $2 does not exist" && return 1

  mv "$1" $TMPFILE
  mv "$2" "$1"
  mv $TMPFILE "$2"
}

###### check whether or not a port on your box is open
portcheck() { for i in "$@";do curl -s "deluge-torrent.org/test-port.php?port=$i" | sed '/^$/d;s/<br><br>/ /g';done; }

has_installed() {
  #command -v foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
  #type foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
  #hash foo 2>/dev/null || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
  type "$1" > /dev/null 2>&1
}

check_installed () {
  #Use 0 for true and 1 for false.
  #if has_installed "$1"; then
  #  return 0
  #else
  #  return 1
  #fi
  type "$1" > /dev/null 2>&1 || { echo >&2 "✖ program/command '$1' is required but it's not installed.  Aborting."; return 1; }
}

setupcolor () {
  hexinput=$( echo "$2" | sed -e "s|#||g" | sed -e "s|0x||g" | tr '[:lower:]' '[:upper:]') #uppercaseing

  a="$(echo $hexinput | cut -c-2  )"
  b="$(echo $hexinput | cut -c3-4 )"
  c="$(echo $hexinput | cut -c5-6 )"

  r="$(echo "ibase=16; $a" | bc)"
  g="$(echo "ibase=16; $b" | bc)"
  b="$(echo "ibase=16; $c" | bc)"

  rp="$(expr $r \* 1000 / 255 )"
  gp="$(expr $g \* 1000 / 255 )"
  bp="$(expr $b \* 1000 / 255 )"
  echo "$(tput initc "$1" "$rp" "$gp" "$bp")"
}

coloredprintf () {
  FG="$2"
  BG="$3"
  re='#*[0x|0X]*[0-9a-fA-F]{6}'

  if [ -z "$BG" ] || ! ( echo "$BG" | grep -Eq "$re" ) ; then
    BG='000000'
  fi
  if [ -z "$FG" ] || ! ( echo "$FG" | grep -Eq "$re" ) ; then
    FG='FFFFFF'
  fi

  if ! ( echo "$BG" | grep -Eq "$re" ) || ! ( echo "$FG" | grep -Eq "$re" ) ; then
    echo "$1"
    return 0
  fi

  if ( has_installed 'python' ) && ( test -r "$DVM_DIR/bin/colortrans.py"  ); then
    printf "$(python "$DVM_DIR/bin/colortrans.py" "$1" "$FG" "$BG" )"
  else
    printf "$(setupcolor 1 "$FG")$(tput setaf 1)$(setupcolor 2 "$BG")$(tput setab 2)$1$(tput sgr0)"
  fi

  tput sgr0
}

coloredecho () {
  echo "$(coloredprintf "$1" "$2" "$3")"
}

# enable color support of ls and also add handy aliases
if has_installed "dircolors"; then
  if [ -r ~/.dircolors ] ; then
    eval $(dircolors -b ~/.dircolors)
  else
    eval $(dircolors -b)
  fi

  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
echo "$(coloredprintf '✔' 00FF00) Aliases"
