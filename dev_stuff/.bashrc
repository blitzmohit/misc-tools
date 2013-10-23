# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)

case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#Custom functions
function trmake()
{
    cd $TRTOP
    ant compile-tr merge-classes
    cd -
}

function trcleanmake(){
    cd $TRTOP/tr; 
    make clean; make;
    cd -
}

function appmake()
{
    cd $TRTOP
    ant compile-applications merge-classes
    cd -
}

function appcleanmake()
{
    cd $TRTOP/Applications;
    make clean; make
    cd -
}


function featuresmake(){
    cd $TRTOP
    ant compile-features merge-classes
    cd -
}

function jsmake(){
    cd $TRTOP/site/js3;
    make;
    cd -;
}

function cssmake(){
    cd $TRTOP/site/css2;
    make;
    cd -;
}

function macspotify(){
    if [ $# -gt 0 ]; then
        ssh rjanardhana@rj-mac-dev.dhcp.tripadvisor.com "/Users/rjanardhana/shpotify-master/spotify '$@'"
    else
        echo -e "Syntax: macspotify <status|play|pause|next|prev|vol up|vol down|vol #|quit>"
    fi
}

function brightness(){
    `python /home/rjanardhana/git/misc-tools/brightness-control/brightness.py`
}

function log(){
    echo -e "Cmd: tail -f /etc/httpd-MAINLINE/logs/tripadvisor.log"
    tail -f /etc/httpd-MAINLINE/logs/tripadvisor.log
}

function trlog(){
    if [ $# -gt 0 ]; then
        echo -e "Cmd: tail -f /etc/httpd-MAINLINE/logs/tripadvisor.log | grep -i '$@'"
        tail -f /etc/httpd-MAINLINE/logs/tripadvisor.log | grep -i "$@"
    else
        echo -e "Syntax: trlog <grep_expression>"
    fi
}

function findtrtop {
    candidate=`pwd`
    while true; do
            if [[ -e "$candidate/GNUmaster" &&  -e "$candidate/tr" && -e "$candidate/Crawlers" ]]; then
                    trtop $candidate
                    break;
            else
                    nextcandidate=${candidate%/*}
                    if [[ "v$nextcandidate" == "v$candidate" || "v$nextcandidate" == "v" ]]; then
                            break;
                    fi
                    candidate=$nextcandidate;
            fi
    done
}

function trtop {
    if (( $# == 1 )); then
            oldscripts=$TRTOP/scripts
            export TRTOP=$1
            export PATH=${PATH//:$oldscripts}:$TRTOP/scripts
    else
            echo $TRTOP
    fi
}

# run single selenium test against mainline
function selsingle(){
    if [ $# -gt 1 ]; then
        echo -e "Cmd: pythontr.sh run-single-test --filename $1 --browser '*firefox' -u ${2}.tripadvisor.com"
        pythontr.sh run-single-test --filename $1 --browser '*firefox' -u ${2}.tripadvisor.com
    else
        echo -e "Syntax: selsingle testFileName testServer[mainline|prerelease]"
    fi
}

# run all live content selenium tests
function selall(){
    ./run-tests --testsuite live_content --browser 'firefox3.6' -u mainline.tripadvisor.com | tee sel_lc_all.log
}

# run same command as jenkins build
function seljenkins(){
    #./run-tests -P X -a bogus-slice -t live_content -u mainline.tripadvisor.com -b '*firefox' -s win09n -F -q -A
    ./run-tests -t live_content -u mainline.tripadvisor.com -b '*firefox' -s win09n -P X -a bogus_slice -F -A -m 1 | tee sel_lc_jenkins.log
}

# custom jshint
function jshint(){
    filename=$@
    echo "/usr/local/bin/jshint --config /home/rjanardhana/.jshint $filename"
    /usr/local/bin/jshint --config /home/rjanardhana/.jshint $filename
}

# custom jshints (simple)
function jshints(){
    filename=$@
    echo "/usr/local/bin/jshint --config /home/rjanardhana/.jshint_simple $filename"
    /usr/local/bin/jshint --config /home/rjanardhana/.jshint_simple $filename
}

# better grep
function gr() {
    echo "grep -Iirn --exclude-dir=\.svn --exclude=*{\-c,\-gen}.{js,css} --color=auto $@ *"
    grep -Iirn --exclude-dir=\.svn --exclude=*{\-c,\-gen}.{js,css} --color=auto $@ * 
}

# shortcut to find
function fd() {
    echo "find . -name $@"
    find . -name $@
}

# dictionary
function dictionary() {
    echo "curl dict://dict.org/d:$@"
    curl dict://dict.org/d:$@
}

#Custom aliases and exports
#exports
#export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
export PROMPT_COMMAND="findtrtop; $PROMPT_COMMAND"
export PS1='[\u@rj-desktop \W]# '
export JAVA_HOME='/usr/lib/jvm/java-7-openjdk-amd64'
export PATH=$PATH:$JAVA_HOME/bin:$TRTOP/scripts:/usr/lib/postgresql/8.4/bin
#export TRTOP='/home/rjanardhana/trsrc-MAINLINE'
export prerelease='/home/rjanardhana/trsrc-PRERELEASE'
export SVN_EDITOR='vim'
export css="$TRTOP/site/css2"
export js="$TRTOP/site/js3"
export HISTTIMEFORMAT="%F %T "
export fb='/home/rjanardhana/cron-scripts/logs/rsync-fbrs.log'
export ACKRC="/home/rjanardhana/.ackrc"

# aliases
# command alias
alias apt-get='sudo apt-get'
alias axel='axel -n 10'
alias eclipse='/home/rjanardhana/ide/eclipse-jee/eclipse & disown'
alias cpv="rsync -P"
alias up="svntr up"
alias so=". ~/.bashrc"
alias vb="vim ~/.bashrc"
alias vv="vim ~/.vimrc"
alias sp="python /home/rjanardhana/git/spotify-random/sp.py"

# dev alias
alias ini="vim config/hosts/rjanardhana-dev.ini"
alias features='vim $TRTOP/config/features.ini'
alias error="tail -f /etc/httpd-MAINLINE/logs/error_log"
alias appconfig="vim $TRTOP/config/webserver/app_tripadvisor.xml"
alias reconf="./configure mainline; make -C config; make -C config/webserver"
alias mac="ssh rjanardhana@rj-mac-dev.dhcp.tripadvisor.com"
alias makeunit='cd $TRTOP; make java_unittests; cd -'
alias c='colordiff | less -R'
alias slogin='echo "svntr login rjanardhana"; svntr login rjanardhana'
alias cunit='cd $TRTOP; ant jar-unittests'
alias su='single_unit_test'

# tweak alias
alias csson="tweak feature on css_CONCAT; tweak feature on css_COMPRESS"
alias cssoff="tweak feature off css_CONCAT; tweak feature off css_COMPRESS"
alias json="tweak feature on JS_CONCAT; tweak feature on JS_COMPRESS"
alias jsoff="tweak feature off JS_CONCAT; tweak feature off JS_COMPRESS"

# directories
alias M='cd /home/rjanardhana/trsrc-MAINLINE'
alias P='cd /home/rjanardhana/trsrc-PRERELEASE'
alias D='cd /home/rjanardhana/tr-data'
alias I='cd /home/rjanardhana/tr-images'
alias L="cd /etc/httpd-MAINLINE/logs/"
alias v='cd $TRTOP/site/velocity_redesign'
alias t='cd $TRTOP'
alias trt='cd $TRTOP/tr'
alias css='cd $TRTOP/site/css2'
alias js='cd $TRTOP/site/js3'

# mobile
alias vm='cd $TRTOP/site/velocity_redesign/mobile'
alias sm='cd $TRTOP/tr/com/TripResearch/servlet/mobile'
alias jm='cd $TRTOP/site/js3/src/mobile'
alias cm='cd $TRTOP/site/css2/mobile'

# svn
alias bdiff='svntr diff -B'

# databases
alias ptma='psql -U tripmaster -h dev-db'
alias ptmo='psql -U tripmonster -h tripmonster'

# misc
alias wallpaper='cd /usr/share/backgrounds'

# temp
#alias L='cd /home/rjanardhana/trsrc-LAST_MINUTE_MOBILE'
alias B='cd /home/rjanardhana/trsrc-MOBILE_BUGS_BATCH_OCT_2013'
