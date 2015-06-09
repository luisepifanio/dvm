#!/usr/bin/env sh
echo "Running $DVM_DIR/.bash_aliases"
#remote ssh common
#alias dynamic_proxy='ssh -D 3100 $USER@$HOST'
#alias map_internal='ssh -L $LOCAL_PORT:$TARGET:$TARGET_PORT $USER@$SSH_HOST'
alias mypublicip='echo "$(curl -s http://ifconfig.me/ip)"'
#alias reloadenv='source $DVM_DIR/.profile'
alias checknode='echo "Node.js: $(node -v)"  && echo "Npm Version: $(npm -v)" '
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -laptr' #oldest first sort
alias labc='ls -lap' #alphabetical sort
alias listFiles='ls . | xargs -n 1 basename'
# I find typing 'cd ..' less than optimal
alias up='cd ..'
alias 2up='cd ../../'
alias 3up='cd ../../../'
alias 4up='cd ../../../../'
# interactive
alias cp='cp -vi'
alias mv='mv -vi'
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
alias root='sudo -i'
alias su='sudo -i'
# reboot / halt / poweroff
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'
#################
alias gcleanbuild='grails clean  && grails test-app :unit --non-interactive'
alias prettyjson='python -m json.tool'
#################
### FUNCTIONS ###
#################
ff () { find . -name $@ -print; }
# Handy Extract Program.
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
#Handy compress Program
compress () {
    tar -cvzf $1 $2
}

serverOn () {
   #^-?[0-9]+([.][0-9]+)?$
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
       echo "error specified port is NOT a number" >&2; exit 1
    fi
    python -m SimpleHTTPServer $1
}
reloadEnv () {
    if [ -f "$PROFILE" ]; then
        source "$PROFILE"
    elif [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        source "$HOME/.bash_profile"
    elif [ -f "$HOME/.zshrc" ]; then
        source "$HOME/.zshrc"
    elif [ -f "$HOME/.profile" ]; then
        source "$HOME/.profile"
    else
        echo "No initializer found"
    fi
}

ignore () {
    echo "$1"  >> .gitignore
}

enable_proxy () {
    re='^[0-9]+$'

    if ! [[ $HTTP_PROXY_PORT =~ $re ]] ; then
       echo "Proxy port is not a number: '$1' ed" >&2; return 0
    fi
    if [ -z "$HTTP_PROXY_HOST" ]; then
        echo "'$HTTP_PROXY_HOST' is not a valid host" >&2; return 0
    fi
    export http_proxy="$HTTP_PROXY_HOST:$HTTP_PROXY_PORT"

    if ! [[ $HTTPS_PROXY_PORT =~ $re ]] ; then
        export HTTPS_PROXY_PORT=$HTTP_PROXY_PORT
    fi
    if [ -z "$HTTPS_PROXY_HOST" ]; then
        export HTTPS_PROXY_HOST=$HTTP_PROXY_HOST
    fi
    export https_proxy="$HTTPS_PROXY_HOST:$HTTPS_PROXY_PORT"
}

disable_proxy () {
  export https_proxy=""
  export http_proxy=""

}
map_ssh_server()
{
    re='^[0-9]+$'

    if ! [[ $1 =~ $re ]] ; then
       echo "el puerto local no es un nro: '$1'" >&2; return 0
    fi
    if [ -z "$2" ]; then
        echo "'$2' no es un host valido" >&2; return 0
    fi
    if ! [[ $3 =~ $re ]] ; then
       echo "el puerto remoto no es un nro: '$3'" >&2; return 0
    fi
    if [ -z "$MELI_USER" ]; then
        echo "Configura la variable MELI_USER ='$MELI_USER'" >&2; return 0
    fi
    if [ -z "$MELI_HOST" ]; then
        MELI_HOST="10.100.41.3"
    fi
    ssh -L $1:$2:$3 $MELI_USER@$MELI_HOST
}

chownThisFolder(){
    local folder="$1"
    if [ -z "$folder" ]; then
      folder="*"
    fi
    sudo chown -R $USER:`id -g -n $USER` "$folder"
}

grails_opts5g()
{
    export GRAILS_OPTS=""
    export GRAILS_OPTS="-Xmx5G -Xms5G -XX:MaxPermSize=5G -XX:PermSize=5G -server -XX:+UseParallelGC -XX:+UseCodeCacheFlushing -XX:MaxInlineLevel=15 -noverify"
    export GRAILS_OPTS="$GRAILS_OPTS -Djava.net.preferIPv4Stack=true -Dsun.reflect.inflationThreshold=100000"
    #export GRAILS_OPTS="$GRAILS_OPTS -Dstringchararrayaccessor.disabled=true"
    export GRAILS_OPTS="$GRAILS_OPTS -Dsun.net.http.allowRestrictedHeaders=true"
    export GRAILS_OPTS="$GRAILS_OPTS -Dfile.encoding=UTF-8"

    echo "Set up for GRAILS_OPTS=$GRAILS_OPTS"
}

grails_opts8g()
{
    export GRAILS_OPTS=""
    export GRAILS_OPTS="-Xmx8G -Xms8G -XX:MaxPermSize=8G -XX:PermSize=8G -server -XX:+UseParallelGC -XX:+UseCodeCacheFlushing -XX:MaxInlineLevel=15 -noverify"
    export GRAILS_OPTS="$GRAILS_OPTS -Djava.net.preferIPv4Stack=true -Dsun.reflect.inflationThreshold=100000"
    export GRAILS_OPTS="$GRAILS_OPTS -Dsun.net.http.allowRestrictedHeaders=true"
    export GRAILS_OPTS="$GRAILS_OPTS -Dfile.encoding=UTF-8"

    echo "Set up for GRAILS_OPTS=$GRAILS_OPTS"
}

grails_opts4g()
{
    export GRAILS_OPTS=""
    export GRAILS_OPTS="-Xmx4G -Xms4G -XX:MaxPermSize=4G -XX:PermSize=4G -server -XX:+UseParallelGC -XX:+UseCodeCacheFlushing -XX:MaxInlineLevel=15 -noverify"
    export GRAILS_OPTS="$GRAILS_OPTS -Djava.net.preferIPv4Stack=true -Dsun.reflect.inflationThreshold=100000"
    export GRAILS_OPTS="$GRAILS_OPTS -Dsun.net.http.allowRestrictedHeaders=true"
    export GRAILS_OPTS="$GRAILS_OPTS -Dfile.encoding=UTF-8"

    echo "Set up for GRAILS_OPTS=$GRAILS_OPTS"
}

grails_opts512M()
{
    #-Djava.awt.headless=true#sthash.YDdxITbz.dpuf
    export GRAILS_OPTS=""
    export GRAILS_OPTS="-Xmx512M -Xms512M -XX:MaxPermSize=512M -XX:PermSize=512M -server -XX:+UseParallelGC -XX:+UseCodeCacheFlushing -XX:MaxInlineLevel=15 -noverify"
    export GRAILS_OPTS="$GRAILS_OPTS -Djava.net.preferIPv4Stack=true -Dsun.reflect.inflationThreshold=100000"
    export GRAILS_OPTS="$GRAILS_OPTS -Dsun.net.http.allowRestrictedHeaders=true"
    export GRAILS_OPTS="$GRAILS_OPTS -Dfile.encoding=UTF-8"

    echo "Set up for GRAILS_OPTS=$GRAILS_OPTS"
}

grails_opts512M()
{
    export GRAILS_OPTS=""
    export GRAILS_OPTS="-Xmx512M -Xms512M -XX:MaxPermSize=512M -XX:PermSize=512M -server -XX:+UseParallelGC -XX:+UseCodeCacheFlushing -XX:MaxInlineLevel=15 -noverify"
    export GRAILS_OPTS="$GRAILS_OPTS -Djava.net.preferIPv4Stack=true -Dsun.reflect.inflationThreshold=100000"
    export GRAILS_OPTS="$GRAILS_OPTS -Dsun.net.http.allowRestrictedHeaders=true"
    export GRAILS_OPTS="$GRAILS_OPTS -Dfile.encoding=UTF-8"

    echo "Set up for GRAILS_OPTS=$GRAILS_OPTS"
}

check_groovy_proxy()
{
    groovy -Dhttp.proxyHost=172.16.0.89 -Dhttp.proxyPort=80 -Dhttps.proxyHost=172.16.0.89 -Dhttps.proxyPort=80  -e 'try{ println "http://ifconfig.me/ip".toURL().text }catch(Exception e){ println "CHECK NETWORK|PROXY!" }'
}
