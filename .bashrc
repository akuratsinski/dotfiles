# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Set screen window title & tty timeout & ...
case "$TERM" in
	xterm-* | screen*)
#		PROMPT_COMMAND='history -a; history -c; history -r; echo -ne "\033k$USER@$HOSTNAME\033\\"'
#		PROMPT_COMMAND='echo -ne "\033k$USER@$HOSTNAME\033\\"'
	;;
	xterm)
#		PROMPT_COMMAND='history -a; history -c; history -r;echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
#		PROMPT_COMMAND='history -a; history -c; history -r;echo -ne "\033k${USER}@${HOSTNAME}\033\\"'
#		PROMPT_COMMAND='echo -ne "\033k${USER}@${HOSTNAME}\033\\"'
	;;
	"" | "unknown")
		TERM=linux
   	;;
	*)
	;;
esac

# are we an interactive shell?
if [ "$PS1" ]; then
  if [ -z "$PROMPT_COMMAND" ]; then
    case $TERM in
    xterm*|vte*)
      if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
          PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
      elif [ "${VTE_VERSION:-0}" -ge 3405 ]; then
          PROMPT_COMMAND="__vte_prompt_command"
      else
          PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
      fi
      ;;
    screen*)
      if [ -e /etc/sysconfig/bash-prompt-screen ]; then
          PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
      else
          PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
      fi
      ;;
    *)
      [ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default
      ;;
    esac
  fi
  # Turn on parallel history
  shopt -s histappend
  history -a
  # Turn on checkwinsize
  shopt -s checkwinsize
  [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
  # You might want to have e.g. tty in prompt (e.g. more virtual machines)
  # and console windows
  # If you want to do so, just add e.g.
  # if [ "$PS1" ]; then
  #   PS1="[\u@\h:\l \W]\\$ "
  # fi
  # to your custom modification shell script in /etc/profile.d/ directory
fi


##########
# Aliasy
##########
if [ -f ~/.bash_aliases_seamless ]; then
    source ~/.bash_aliases_seamless
fi

##########
# fzf
#########
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#########
# git prompt
#########
if [ -f ~/.bash/git-prompt.sh ]; then
	source ~/.bash/git-prompt.sh
fi

##########
# Timeout dla TTY
##########
TTY=$(tty)
[ ${TTY:0:8} = '/dev/tty' ] && [ ${TTY:8:1} != '1' ] && export TMOUT=180
unset TTY

##########
# Bash completition
##########
if [ -x ~/.bash/docker_completer ]; then
	. ~/.bash/docker_completer
fi
if [ -x /usr/local/bin/aws_completer ]; then
	complete -C '/usr/local/bin/aws_completer' aws
fi
if [ -x ~/.bash/bash_completion_tmux.sh ]; then
	. ~/.bash/bash_completion_tmux.sh
fi

##########
# dircorlors
##########
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

##########
# DROP CACHES
##########
alias drop_caches='echo -n `free -m | awk "/Mem/ {print \\$4}"` && sudo sh -c "echo 3 > /proc/sys/vm/drop_caches" && echo -n "-->" && echo -n `free -m | awk "/Mem/ {print \\$4}"` && echo'

##########
# EXPORTY
##########
unset GNOME_DESKTOP_SESSION_ID
# ANSI color codes
RS="\[\033[0m\]"    # reset
HC="\[\033[1m\]"    # hicolor
UL="\[\033[4m\]"    # underline
INV="\[\033[7m\]"   # inverse background and foreground
FBLK="\[\033[30m\]" # foreground black
FRED="\[\033[31m\]" # foreground red
FGRN="\[\033[32m\]" # foreground green
FYEL="\[\033[33m\]" # foreground yellow
FBLE="\[\033[34m\]" # foreground blue
FMAG="\[\033[35m\]" # foreground magenta
FCYN="\[\033[36m\]" # foreground cyan
FWHT="\[\033[37m\]" # foreground white
BBLK="\[\033[40m\]" # background black
BRED="\[\033[41m\]" # background red
BGRN="\[\033[42m\]" # background green
BYEL="\[\033[43m\]" # background yellow
BBLE="\[\033[44m\]" # background blue
BMAG="\[\033[45m\]" # background magenta
BCYN="\[\033[46m\]" # background cyan
BWHT="\[\033[47m\]" # background white
#export PS1="$RS$FBLE<$RS$FRED\u$HC$FWHT@$FRED\H$RS$FBLE>[$FWHT\t$FBLE] ($HC\w$RS$FBLE)$FWHT$HC\$$RS "
export PS1="$FBLE[$FWHT\t$FBLE] $FRED($FYEL\w$FRED)$FWHT$HC\$$RS \$(__git_ps1 \"$FRED($FCYN%s$FRED) \")$RS"
#PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
#export PS1='\[[1;31;30m\]<\[[1;31;34m\]\u\[[1;37;37m\]@\[[1;31;32m\]\H\[[1;31;30m\]>\[[1;30;30m\][\[[0;37;37m\]\t\[[1;30;30m\]] (\[[1;37;37m\]\w\[[1;30;30m\])\[[1;37;37m\]\$ \[[0m\]'
#przed solarized export PS1='\[\033[1;30m\]<\[\033[1;34m\]\u\[\033[1;37m\]@\[\033[1;32m\]\H\[\033[1;30m\]>\[\033[1;30m\][\[\033[0;37m\]\t\[\033[1;30m\]] (\[\033[1;37m\]\w\[\033[1;30m\])\[\033[1;37m\]\$ \[\033[0m\]'
#export PS1='\[\033[0;34m\]<\[\033[0;31m\]\u\[\033[1;37m\]@\[\033[1;31m\]\H\[\033[0;34m\]>\[\033[0;34m\][\[\033[0;37m\]\t\[\033[0;34m\]] (\[\033[1;37m\]\w\[\033[0;34m\])\[\033[1;37m\]\$ \[\033[0m\]'
export PATH="$PATH:/usr/local/bin:/usr/bin:/bin/usr/local/bin:/usr/X11R6/bin:/usr/lib/perl5:$HOME/.bin:$JAVA_HOME/bin"
#export GTK2_RC_FILES="/home/konus/.gtkrc-2.0"											# qtgtkstyle
export AWT_TOOLKIT="MToolkit"																			# ACC+compiz
export HISTFILESIZE=500000																				# wielkosc pliku .bash_history
export HISTCONTROL=ignoreboth
export HISTIGNORE="&:[ ]*:exit:history:ls:l:clear:[bf]g"		# komendy nie wpisywane do .bash_history
export EDITOR="vim"
export VISUAL="vim"
export PAGER="/usr/bin/less"
export LESS_TERMCAP_mb=$'\E[01;31m'											 					# begin blinking
export LESS_TERMCAP_md=$'\E[01;31m' 															# begin bold
export LESS_TERMCAP_me=$'\E[0m'																		# end mode
export LESS_TERMCAP_se=$'\E[0m'																		# end standout-mode
export LESS_TERMCAP_so=$'\E[01;44;33m'														# begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'																		# end underline
export LESS_TERMCAP_us=$'\E[01;32m'																# begin underline
export LESS="-RSM~gIsw"
#    R - Raw color codes in output (don't remove color codes)
#    S - Don't wrap lines, just cut off too long text
#    M - Long prompts ("Line X of Y")
#    ~ - Don't show those weird ~ symbols on lines after EOF
#    g - Highlight results when searching with slash key (/)
#    I - Case insensitive search
#    s - Squeeze empty lines to one
#    w - Highlight first line after PgDn
export SSH_OPT='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

##########
# Bash settings
##########
# On
shopt -s cdspell								# poprawia zle wprowadzone nazwy katalogow
shopt -s checkwinsize								# przed wykonaniem kazdej komendy sprawdza wielkosc ekranu
shopt -s expand_aliases								# po TAB pokazuje alias'y
shopt -s cdable_vars								# if cd arg is not valid, assumes its a var defining a dir
shopt -s cmdhist								# save multi-line commands in history as single line
shopt -s dotglob								# include dotfiles in pathname expansion
shopt -s expand_aliases								# expand aliases
shopt -s extglob								# enable extended pattern-matching features
shopt -s histappend								# append to (not overwrite) the history file
shopt -s hostcomplete								# attempt hostname expansion when @ is at the beginning of a word
shopt -s nocaseglob								# pathname expansion will be treated as case-insensitive
shopt -s no_empty_cmd_completion						# If set, and readline is being used, Bash will not attempt to search the PATH for possible completions when completion is attempted on an empty line. 
shopt -s promptvars								# If set, prompt strings undergo parameter expansion, command substitution, arithmetic expansion, and quote removal after being expanded using the prompt special sequences. This option is enabled by default. 
# Off
shopt -u mailwarn								# nie ostrzega o nowych mailach
#set -o ignoreeof								# stops ctrl+d from logging me out

##########
# Funkcje
##########
function dig_int() {
	dig -tAXFR seamless.internal @10.2.31.22 | grep $1
}
function settitle() {
	printf "\033k$1\033\\"
}
function remotecam () {
	cvlc v4l2:///dev/video0 :v4l2-standard= :input-slave=alsa://hw:0,0 :live-caching=300 :sout="#transcode{vcodec=WMV2,vb=80­0,scale=1,acodec=wma2,ab=128,channels=2,samplerate=44100}:http{dst=:2220/stream.­wmv}"
}
function rename_test() {
for panes in $(tmux list-windows -F '#{window_index}'); do
	panenames=$(tmux list-panes -t $panes -F '#{pane_title}' | sed -e 's/:.*$//' -e 's/^.*@//' | uniq); windowname=$(echo ${panenames} | sed -e 's/ /|/g');
	tmux rename-window -t $panes $windowname;
done
}
function ssh0() {
	  if [[ $# == 0 || -z $TMUX ]]; then
			#should match 99.9% of SSH users
			user_regex='[a-zA-Z][a-zA-Z0-9_]+'
			#match domains
			host_regex='([a-zA-Z][a-zA-Z0-9\-]*\.)*[a-zA-Z][a-zA-Z0-9\-]*'
			#match paths starting with / and empty strings (which is valid for our use!)
			path_regex='(\/[A-Za-z0-9_\-\.]+)*\/?'
			#the complete regex
			master_regex="^$user_regex\@$host_regex\:$path_regex\$"
			tmux set-window-option automatic-rename "off" 1>/dev/null
    	tmux rename-window "$*"
    	command ssh "$@"
			tmux set-window-option automatic-rename "on" 1>/dev/null
		else
			command ssh "$@"
		fi
}
function ssh1() {
    # Do nothing if we are not inside tmux or ssh is called without arguments
    if [[ $# == 0 || -z $TMUX ]]; then
        command ssh $@
        return
    fi
    # The hostname is the last parameter (i.e. ${(P)#})
    local remote=${${(P)#}%.*}
    local old_name="$(tmux display-message -p '#W')"
    local renamed=0
    # Save the current name
    if [[ $remote != -* ]]; then
        renamed=1
        tmux rename-window $remote
    fi
    command ssh $@
    if [[ $renamed == 1 ]]; then
        tmux rename-window "$old_name"
    fi
}
function setgov ()
{
    echo "$1" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 
}
function pdfpextr() {
    # this function uses 3 arguments:
    #     $1 is the first page of the range to extract
    #     $2 is the last page of the range to extract
    #     $3 is the input file
    #     output file will be named "inputfile_pXX-pYY.pdf"
    gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
       -dFirstPage=${1} \
       -dLastPage=${2} \
       -sOutputFile=${3%.pdf}_p${1}-p${2}.pdf \
       ${3}
}
function jc {
	host=$1
	proxy_port=${2:-8123}
	jconsole_host=wrongway
	ssh -f -D$proxy_port $host 'while true; do sleep 1; done' ssh_pid=`ps ax | grep "[s]sh -f -D$proxy_port" | awk '{print $1}'`
	jconsole -J-DsocksProxyHost=localhost -J-DsocksProxyPort=$proxy_port service:jmx:rmi:///jndi/rmi://${jconsole_host}:8181/jmxrmi
	kill $ssh_pid
}
function genpasswd() {
	local l=$1
       	[ "$l" == "" ] && l=16
      	tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}
function pps() {
	ps aux | grep "$@" | grep -v 'grep';
}
function telnet_proc() {
	timeout 1 bash -c 'cat < /dev/null > /dev/tcp/'$1'/'$2''
	response="$?"
	if [ $response == "0" ]; then
			echo "$1:$2 connection successfull"
	elif [ $response == "1" ]; then
			echo "$1:$2 connection failed"
	elif [ $response == "124" ]; then
			echo "$1:$2 connection timeout"
	fi
}
#########
# fzf
########
# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
# fkill - kill process
fkill() {
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    kill -${1:-9} $pid
  fi
}
# fbr - checkout git branch (including remote branches)
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}
# fcoc - checkout git commit
fcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}
# fshow - git commit browser
fshow() {
  local out sha q
  while out=$(
      git log --decorate=short --graph --oneline --color=always |
      fzf --ansi --multi --no-sort --reverse --query="$q" --print-query); do
    q=$(head -1 <<< "$out")
    while read sha; do
      [ -n "$sha" ] && git show --color=always $sha | less -R
    done < <(sed '1d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
  done
}
# fs [FUZZY PATTERN] - Select selected tmux session
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}
# ftpane - switch pane
ftpane () {
  local panes current_window target target_window target_pane
  panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
  current_window=$(tmux display-message  -p '#I')

  target=$(echo "$panes" | fzf) || return

  target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
  target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

  if [[ $current_window -eq $target_window ]]; then
    tmux select-pane -t ${target_window}.${target_pane}
  else
    tmux select-pane -t ${target_window}.${target_pane} &&
    tmux select-window -t $target_window
  fi
}
