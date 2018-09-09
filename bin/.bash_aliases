#!/usr/bin/env sh
#remote ssh common
#alias dynamic_proxy='ssh -D 3100 $USER@$HOST'
#alias map_internal='ssh -L $LOCAL_PORT:$TARGET:$TARGET_PORT $USER@$SSH_HOST'
alias checknode='echo "Node.js: $(node -v)" && echo "Npm Version: $(npm -v)" '
# some more ls aliases
alias l='ls -CF'
alias ll_abc='ls -lap' #alphabetical sort
alias ll_files='ls . | xargs -n 1 basename'
alias ll_hidden='ls -A'
alias ll_oldest_first='ls -laptr' #oldest first sort
alias ll='ls -alF'
# I find typing 'cd ..' less than optimal
alias up='cd ..'
alias 2up='cd ../../'
alias 3up='cd ../../../'
alias 4up='cd ../../../../'
# Miscelaneus
alias cp='cp -vi'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias mv='mv -vi'
alias ping='ping -c 10'
alias svim='sudo vim'
alias trash='mkdir -p $HOME/.Trash/ && mv --target-directory=$HOME/.Trash/'
# Change mods
alias chmod_000='chmod -R 000'
alias chmod_644='chmod -R 644'
alias chmod_666='chmod -R 666'
alias chmod_755='chmod -R 755'
alias chmod_777='chmod -R 777'
alias chmod_exec='chmod a+x'
#####################
###    CDARGS     ###
#####################
alias goto='cv'
alias savedir='ca'
# DISK USAGE
alias disk_usage_bytes='du -cks * | sort -rn | head'
alias disk_usage_fs='df -H'
alias disk_usage_pwd='du -ch'
alias disk_usage_top10='du -hsx * | sort -rn | head -10'
alias ll_partitions_fdisk='sudo fdisk -l'
alias ll_partitions='sudo lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL'
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
#Text processing#####
alias single_spaces="sed 's|\s\+| |g'"
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
# Fun
alias weather-cba="curl http://wttr.in/cordoba"
alias weather="curl http://wttr.in"

# hace push al branch en el cual estoy parado, siempre en origin
gitpush () {
  BRANCH=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/')
  git push origin "$BRANCH"
}

#################
### FUNCTIONS ###
#################
upper () {
  [ $# -ne 1  ] && echo "upper requires 1 argument" && return 1
  check_installed tr
  echo "$1" | tr '[:lower:]' '[:upper:]'
}

lower () {
  [ $# -ne 1  ] && echo "lower requires 1 argument" && return 1
  check_installed tr
  echo "$1" | tr '[:upper:]' '[:lower:]'
}
### Plataform ###
if_nix () {
  [ $# -ne 1  ] && echo "if_nix requires 1 argument" && return 1

  TARGETOS="$(upper $1)"

  OS="UNKNOWN"
  if [ -z "$OSTYPE" ]; then
    # Detect the platform (alternative to $OSTYPE)
    OS="$(uname)"
    case $OS in
      'AIX')        OS='AIX'          ;;
      'Darwin')     OS='OSX'          ;;
      'FreeBSD')    OS='BSD'          ;;
      'Linux')      OS='LINUX'        ;;
      'SunOS')      OS='SOLARIS'      ;;
      'WindowsNT')  OS='WINDOWS'      ;;
      *)            OS="UNKNOWN:$OS"  ;;
    esac
  else
    case "$OSTYPE" in
      bsd*)         OS='BSD'          ;;
      darwin*)      OS='OSX'          ;; 
      linux*)       OS='LINUX'        ;;
      msys*)        OS='WINDOWS'      ;;
      solaris*)     OS='SOLARIS'      ;;
      *)            OS="UNKNOWN:$OS"  ;;
    esac
  fi

  [ "$OS" == "$TARGETOS" ];
}

if_os_osx () { if_nix OSX; }
if_os_linux () { if_nix LINUX; }
if_os_windows () { if_nix WINDOWS; }

ff () {
  find . -name "$@" -print;
}
# Handy Extract Program.
extract () {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xvjf "$1"    ;;
      *.tar.gz)    tar xvzf "$1"    ;;
      *.tar.*)     tar xf "$1"      ;;
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

pcdl () {
  [ $# -ne 1  ] && echo "'pcdl' requires an url" && return 1
  check_installed proxychains
  proxychains sudo wget --continue "$1"
}

reloadEnv () {
  unset add_param_to
  unset allips
  unset catecho
  unset change_property_value_of
  unset change_value_of
  unset check_groovy_proxy
  unset check_installed
  unset chownThisFolder
  unset coloredecho
  unset coloredprintf
  unset compress
  unset disable_jvm_custom_timeouts
  unset disable_jvm_dependency_logs
  unset disable_jvm_plumbr_agent
  unset disable_proxy
  unset enable_jvm_custom_timeouts
  unset enable_jvm_dependency_logs
  unset enable_jvm_plumbr_agent
  unset enable_proxy
  unset extract
  unset ff
  unset getCellAt
  unset gitpull
  unset gitpush
  unset grails_opts
  unset grails_opts_clean
  unset grails_opts_test
  unset has_installed
  unset history_search
  unset host2ip
  unset if_nix
  unset if_os_linux
  unset if_os_osx
  unset if_os_windows
  unset ignore
  unset java_opts_clean
  unset java_opts_ivy_logger
  unset lls
  unset mypublicip
  unset pcdl
  unset pidOnPort
  unset portcheck
  unset psgrep
  unset reloadEnv
  unset remove_param_of
  unset serverOn
  unset setupcolor
  unset show_grails_opts
  unset string_sorter
  unset swapfiles
  unset wheather

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

history_search () {
  aterm="$1"
  if [ -z "$aterm" ]; then
    echo "'$aterm' is not a valid search" >&2; return 0
  fi
  history | grep "$aterm"
}

show_grails_opts () {
  echo "✔ Set up for GRAILS_OPTS='$GRAILS_OPTS'"
}

grails_opts () {
  if [ -z "$1" ]; then
    echo "'$1' is not a valid config" >&2; return 0
  fi

  GOPTS=""
  #Heap and PermGen Sizing
  add_param_to JAVA_OPTS "-Xmx$1"
  add_param_to JAVA_OPTS "-Xms128M"

  #Comment line below for java 8
  #GOPTS="$GOPTS -XX:PermSize=1G -XX:MaxPermSize=1G"

  # 1. Garbage collector configuration parallel
  #GOPTS="$GOPTS -XX:+UseParallelGC -XX:+UseParallelOldGC"
  # 2. Garbage collector configuration concurrent mark sweep

  add_param_to JAVA_OPTS "-XX:+UseParNewGC"
  add_param_to JAVA_OPTS "-XX:+UseConcMarkSweepGC"

  change_property_value_of JAVA_OPTS -XX:MinHeapFreeRatio 50
  change_property_value_of JAVA_OPTS -XX:MaxHeapFreeRatio 75
  add_param_to JAVA_OPTS "-XX:+CMSPrecleaningEnabled"

  #Comment line below for java 8
  #GOPTS="$GOPTS -XX:+CMSPermGenPrecleaningEnabled"
  add_param_to JAVA_OPTS "-XX:+CMSClassUnloadingEnabled"
  add_param_to JAVA_OPTS "-XX:+UseCMSInitiatingOccupancyOnly"
  change_property_value_of JAVA_OPTS -XX:CMSInitiatingOccupancyFraction 65

  add_param_to JAVA_OPTS "-XX:+CMSParallelRemarkEnabled"
  add_param_to JAVA_OPTS "-XX:+ScavengeBeforeFullGC"
  add_param_to JAVA_OPTS "-XX:+CMSScavengeBeforeRemark"

  change_property_value_of JAVA_OPTS -XX:NewRatio 8
  change_property_value_of JAVA_OPTS -XX:SurvivorRatio 32

  # Optimizations
  change_property_value_of JAVA_OPTS -XX:MaxJavaStackTraceDepth 30
  change_property_value_of JAVA_OPTS -XX:SoftRefLRUPolicyMSPerMB 10

  add_param_to JAVA_OPTS '-XX:+EliminateLocks'
  add_param_to JAVA_OPTS '-XX:+UseBiasedLocking'
  add_param_to JAVA_OPTS '-Xshare:off'
  add_param_to JAVA_OPTS '-server' 
  add_param_to JAVA_OPTS '-noverify'
  change_property_value_of JAVA_OPTS '-Djava.awt.headless' true 
  change_property_value_of JAVA_OPTS '-Djava.net.preferIPv4Stack' true
  change_property_value_of JAVA_OPTS '-Dgroovy.use.classvalue' true
  #

}

grails_opts_clean () {
  export GRAILS_OPTS=""
  show_grails_opts
}

java_opts_clean () {
  export JAVA_OPTS=""
  echo "✔ Set up for JAVA_OPTS='$JAVA_OPTS'"
}

java_opts_ivy_logger () {
  export JAVA_OPTS="-Dgroovy.grape.report.downloads=true -Divy.message.logger.level=4"
  echo "✔ Set up for JAVA_OPTS='$JAVA_OPTS'"
}

grails_opts_test () {
  grails_opts "4G"
}

string_sorter () {

  INPUT="$1"
  [ -z "$INPUT" ] && INPUT=""
  SEP="$2"
  [ -z "$SEP" ] && SEP=","

  echo "$INPUT" | tr "$SEP" "\n" | sort | uniq | tr "\n" "$SEP" | sed "s|$SEP$|\n|"
}

add_param_to () {
  if [ -z "$1" ]; then
    echo "'$1' variable name should be not null" >&2; return 0
  fi

  if [ -z "$2" ]; then
    echo "'$2' param should be not null" >&2; return 0
  fi

  DLRSIGN='$'
  VARNAME="$1"
  PARAM="$2"

  BEFORE=$( eval echo "$DLRSIGN$VARNAME" )
  [ -z "$BEFORE" ] && export "$VARNAME"="" #Creates empty

  AFTER=$( echo "$BEFORE $PARAM" | sed 's| \{1,\}| |g' )

  AFTER=$( string_sorter "$AFTER" ' ' )
  [ ! -z "$AFTER" ] && export "$VARNAME"="$AFTER"
  
  diff  <(echo "$BEFORE" ) <(echo "$AFTER")

}

remove_param_of () {
  # removes params of type "$PARAM" "server"
  if [ -z "$1" ]; then
    echo "'$1' variable name should be not null" >&2; return 0
  fi

  if [ -z "$2" ]; then
    echo "'$2' param should be not null" >&2; return 0
  fi

  DLRSIGN='$'
  MINUSSIGN=''
  VARNAME="$1"
  PARAM="$2"

  BEFORE=$( eval echo "$DLRSIGN$VARNAME" )
  AFTER=$( echo "$BEFORE" | sed -e "s|$MINUSSIGN$PARAM||g" | sed 's| \{1,\}| |g' )

  AFTER=$( string_sorter "$AFTER" ' ' )
  [ ! -z "$BEFORE" ] && export "$VARNAME"="$AFTER"
  diff  <(echo "$BEFORE" ) <(echo "$AFTER")
}

change_property_value_of () {
  # Changes values of type "$KEY=$VALUE" i.e -XX:MinHeapFreeRatio=50
  if [ -z "$1" ]; then
    echo "'$1' variable name should be not null" >&2; return 0
  fi

  if [ -z "$2" ]; then
    echo "'$2' key should be not null" >&2; return 0
  fi

  if [ -z "$3" ]; then
    echo "'$3' value should be not null" >&2; return 0
  fi

  DLRSIGN='$'
  VARNAME="$1"
  KEY="$2"
  VALUE="$3"

  BEFORE=$( eval echo "$DLRSIGN$VARNAME" )
  [ -z "$BEFORE" ] && export "$VARNAME"="" #Creates empty
  AFTER=$( echo "$BEFORE $KEY=$VALUE" | sed -E "s|(\s*$KEY)=([a-zA-Z0-9\.]*)\s*|\1=$VALUE |g" | sed 's| \{1,\}| |g' )
  AFTER=$( string_sorter "$AFTER" ' ' )
  [ ! -z "$AFTER" ] && export "$VARNAME"="$AFTER"
  diff  <(echo "$BEFORE" ) <(echo "$AFTER")

}

remove_property_value_of () {
  # Changes values of type "$KEY=$VALUE" i.e -XX:MinHeapFreeRatio=50
  if [ -z "$1" ]; then
    echo "'$1' variable name should be not null" >&2; return 0
  fi

  if [ -z "$2" ]; then
    echo "'$2' key should be not null" >&2; return 0
  fi

  DLRSIGN='$'
  VARNAME="$1"
  KEY="$2"

  BEFORE=$( eval echo "$DLRSIGN$VARNAME" )
  AFTER=$( echo "$BEFORE" | sed -E "s|(\s*$KEY)=([a-zA-Z0-9\.]*)\s*| |g" | sed 's| \{1,\}| |g' )
  AFTER=$( string_sorter "$AFTER" ' ' )
  [ ! -z "$BEFORE" ] && export "$VARNAME"="$AFTER"
  diff  <(echo "$BEFORE" ) <(echo "$AFTER")

}

check_groovy_proxy () {
  groovy -Dhttp.proxyHost="$HTTP_PROXY_HOST" -Dhttp.proxyPort="$HTTP_PROXY_PORT" -Dhttps.proxyHost="$HTTPS_PROXY_HOST" -Dhttps.proxyPort="$HTTPS_PROXY_PORT"  -e 'try{ println "http://ifconfig.me/ip".toURL().text }catch(Exception e){ println "CHECK NETWORK|PROXY!" }'
}

enable_jvm_custom_timeouts() {
  change_property_value_of JAVA_OPTS -Dsun.net.client.defaultConnectTimeout 500
  change_property_value_of JAVA_OPTS -Dsun.net.client.defaultReadTimeout 2000
  echo "\$JAVA_OPTS='$JAVA_OPTS'"
}

disable_jvm_custom_timeouts() {
  remove_property_value_of JAVA_OPTS -Dsun.net.client.defaultConnectTimeout
  remove_property_value_of JAVA_OPTS -Dsun.net.client.defaultReadTimeout

}

enable_jvm_plumbr_agent() {
  PLUMBR_OPTS="-javaagent:$DEVTOOLS/PLUMBR_HOME/plumbr.jar"
  export JAVA_OPTS="$JAVA_OPTS $PLUMBR_OPTS"
  echo "\$JAVA_OPTS='$JAVA_OPTS'"
}

disable_jvm_plumbr_agent() {
  PLUMBR_OPTS="-javaagent:path-to/plumbr.jar"
  export JAVA_OPTS=$( echo $JAVA_OPTS | sed -e "s| $PLUMBR_OPTS||g"  )
  echo "\$JAVA_OPTS='$JAVA_OPTS'"
}

enable_jvm_dependency_logs() {
  change_property_value_of JAVA_OPTS -Dgroovy.grape.report.downloads true
  change_property_value_of JAVA_OPTS -Divy.message.logger.level 4

  echo "\$JAVA_OPTS='$JAVA_OPTS'"
}

disable_jvm_dependency_logs() {
  remove_property_value_of JAVA_OPTS -Dgroovy.grape.report.downloads
  remove_property_value_of JAVA_OPTS -Divy.message.logger.level
  echo "\$JAVA_OPTS='$JAVA_OPTS'"
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

allips() {
  ifconfig | awk '/inet / {sub(/addr:/, "", $2); print $2}'
}

host2ip() {
  [ $# -ne 1  ] && echo "host2ip: 1 arguments needed" && return 1
  [ -z "$1" ] && echo "host2ip: $1 does not exist" && return 1

  if ( has_installed 'getent' ) && ( has_installed 'awk' ); then
    echo "$( getent hosts "$1" | awk '{ print $1 }' )"
  elif ( has_installed 'dig' ); then
    echo "$( dig +short "$1" )"
  fi

}

catecho () {
    if [ $# -eq 0 ]; then
        cat
    else
        echo "$*"
    fi
}

wheather() {
  aterm="$1"
  if [ -z "$aterm" ]; then
    curl 'wttr.in'
  else
    curl "wttr.in/$aterm"
  fi
}

getCellAt() {

  if [ "$#" -ne 2 ]; then
    echo 'You need at least 2 params row column or file'
    return 1      
  fi

  ROW="$1"
  COL="$2"

  catecho | awk "{print \$${COL}}" | sed "${ROW}q;d"
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