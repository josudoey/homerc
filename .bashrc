# Set the following to make all x terminals have proper PS1 and PS2
# \033[0;30m - Black
# \033[0;31m - Red
# \033[0;32m - Green
# \033[0;33m - Orange
# \033[0;34m - Blue
# \033[0;35m - Cyan
# \033[0;36m - Light Blue
# \033[0;37m - Grey
# \033[0;39m - White
if [ -z "$PS1" ]; then #for scp use.
    return;
fi

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export LANG=en_US.UTF-8
export TERM=xterm-256color
export PS1="\[\e[1;36m\]\t!\! \[\e[01;33m\]\u\[\e[m\]@\h\[\e[0m\]:\[\e[01;34m\]\w\[\e[91m\]\$(parse_git_branch)\[\e[0m\]\$ "
PATH=${PATH}:${HOME}/bin
export EDITOR=/usr/bin/vim

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
test -d ~/.histfile ||mkdir ~/.histfile
alias hw="history -w ~/.histfile/last"
alias ha="history -a ~/.histfile/last"
alias hr="history -r ~/.histfile/last"
alias hn="history -n ~/.histfile/last"
alias hc="history -c"

export HISTFILE=~/.histfile/hist

if [ "$?WINDOW" ] ; then
   export HISTFILE=~/.histfile/hist$WINDOW
fi

if [ "$TERM_PROGRAM" == "vscode" ] ; then
    for ((i=0;;i++)) do
        id=$(basename $PWD|shasum|cut -d ' ' -f 1)
        pidfile=~/.histfile/.vscode.$id.$i.pid
        if [ ! -f "$pidfile" ]; then
            echo $$ > $pidfile
            export HISTFILE=~/.histfile/vscode.$id.$i
            break
        fi
        if kill -0 $(cat $pidfile) 2>/dev/null; then
            continue
        fi
        echo $$ > $pidfile
        export HISTFILE=~/.histfile/vscode.$id.$i
        break
    done
fi

if [[  `uname` =~ "Linux" ]] ; then
   alias ls='ls --color=auto'
   alias ll='ls -alF'
   alias la='ls -A'
   alias l='ls -CF'
   alias grep='grep --color=auto'
fi

if [[  `uname` =~ "Darwin" ]] ; then
    #ref http://blog.longwin.com.tw/2006/07/color_ls_in_bash_2006/
    export CLICOLOR="YES"
    export LSCOLORS=ExHxcxdxCxegedhbhghcad
    alias ll='ls -l'
    alias la='ls -A'
    alias l='ls -CF'
fi

if [[  `uname` =~ "FreeBSD" ]] ; then
    export EDITOR=/usr/local/bin/vim
    export CLICOLOR="YES"
    export LSCOLORS=ExHxcxdxCxegedhbhghcad
    alias ll='ls -l'
    alias la='ls -A'
    alias l='ls -CF'
fi

if [[ -z "$PUBLIC_ADDRESS" ]] ;then
    export PUBLIC_ADDRESS="`dig +short myip.opendns.com @resolver1.opendns.com`"
fi

#golang
if [ -x `which go` ] ; then
    mkdir -p "$HOME/go"
    export GOPATH="$HOME/go"
    export PATH=$PATH:$GOPATH/bin
    export GOSUMDB=off
fi
