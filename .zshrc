# Where to store the shell history.
HISTFILE=~/.history

# How many commands to store.
HISTSIZE=100000

SAVEHIST=$HISTSIZE

# Change to directories without using `cd'.
setopt auto_cd

# The characters `~', `^' and `#' are part of patterns.
setopt extended_glob

# Also save the beginning and duration of commands.
setopt extended_history

# Don't add commands to the history if they are duplicates of the previous command.
setopt hist_ignore_dups

# Add new commands to the history after they were entered.
setopt inc_append_history

# Try to make the completion list smaller.
setopt list_packed

# Immediately report the status of background jobs.
setopt notify

# Don't beep.
setopt no_beep

# Don't beep.
setopt no_hist_beep

# Allow the short forms of certain constructs.
setopt short_loops

# Disable terminal bell.
if [ -n "$DISPLAY" ]
then
  xset b off
fi

zstyle :compinstall filename '~/.zshrc'

####
# Keybindings

# bindkey '^N'    forward-word                         # <Ctrl> + N
# bindkey '^B'    backward-word                        # <Ctrl> + B
bindkey '^R'    history-incremental-search-backward  # <Ctrl> + R
# bindkey '\e[3~' delete-char                          # <Del>/<Entf>
# bindkey '^[[2~' overwrite-mode                       # <Ins>/<Einfg>
# bindkey -e                                           # emacs compatible mode

# This is necessary to make ctrl+left/right work in combination with urxvt.
bindkey "\eOc"    forward-word
bindkey "\eOd"    backward-word
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[5C"   forward-word
bindkey "\e[5D"   backward-word
bindkey "\e\e[C"  forward-word
bindkey "\e\e[D"  backward-word

####
# Miscellaneous
#
eval `dircolors ~/.dir_colors`
autoload -Uz compinit
compinit
umask 077        # dirs:  rwx------
                 # files: rw-------
ulimit -s 8192   # stacksize
ulimit -l 32     # locked-in-memory size

autoload -U colors && colors

# Load version control information
# autoload -Uz vcs_info
# precmd() { vcs_info }
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
precmd() {
    vcs_info
}

# Format the vcs_info_msg_0_ variable
#zstyle ':vcs_info:git:*' formats 'on branch %b'

BRANCH=$'\uE0A0'

# zstyle ':vcs_info:git*' formats "(%{$fg_bold[yellow]%}%s%{$reset_color%}%{$BRANCH%}%{$fg_bold[blue]%}%b%{$reset_color%}%m%u%c%{$reset_color%}) "
zstyle ':vcs_info:git*' formats " %{$fg_bold[cyan]%}(%{$fg_bold[yellow]%}%s%{$fg[green]%}:%{$fg_bold[yellow]%}%b%{$reset_color%}%m%u%c%{$reset_color%}%{$fg_bold[cyan]%})"
zstyle ':vcs_info:git*' actionformats "%s  %r/%S %b %m%u%c "
#zstyle ':vcs_info:git*' formats "%s  %r/%S %b (%a) %m%u%c "

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
#PROMPT='%n in ${PWD/#$HOME/~} ${vcs_info_msg_0_} > '
#RPROMPT=\$vcs_info_msg_0_
#RPROMPT='${vcs_info_msg_0_}%# '

# What the shell prompt looks like.
# Line 1: Username (%n)
# Line 2: Current directory (relative, or absolute)
# Line 3: Shell prompt ($ in case of a 0 return code)
# Line 4: Shell prompt (NUM in case of a non-0 return code)
PROMPT=\
$'%{$fg[green]%}%n'\
$' %{$fg[blue]%}%0(5c,…/%c,%~)'\
$'%{$fg[red]%}%{$fg[blue]%}%0(?,%{$fg_bold[blue]%}'\
$'${vcs_info_msg_0_} $,'\
$'%{$fg_bold[red]%} %?%{$fg_bold[blue]%} $%s)%b '


####
# Tab Completion

ZLS_COLORS=$LS_COLORS



unset GPG_AGENT_INFO

# Shell parameters.

REPORTTIME=5

export KEYTIMEOUT=1

export GOROOT=$HOME/sw/go
export GOPATH=$HOME/go
export GOBIN=${GOPATH}/bin
export GO111MODULE=on

export HOSTNAME="`hostname`"
export EDITOR=vim
export VISUAL="${EDITOR}"
export MAIL=$HOME/mail/sysmail
export PAGER=less

export PATH=$PATH:/home/${USER}/.local/bin
export PATH=$PATH:/home/${USER}/bin
export PATH=$PATH:$GOROOT/bin

# Colour codes for terminals that support 256 colours.
export LESS_TERMCAP_md=$'\E[1;31m' # Begin blink (bright red).
export LESS_TERMCAP_me=$'\E[0m'    # Reset bold/blink.
export LESS_TERMCAP_us=$'\E[32m'   # Begin underline (green).
export LESS_TERMCAP_ue=$'\E[0m'    # Reset underline.

# Coloured matches for grep.
# export GREP_COLORS='ms=38;5;74:fn=38;5;240:se=0;38'
# <https://askubuntu.com/questions/1042234/modifying-the-color-of-grep>ma
export GREP_COLORS='ms=0;33;40:fn=0;34:se=0;36'

# TERMINAL is for i3 to figure out which is our default terminal.
export TERMINAL=urxvt

export LD_LIBRARY_PATH=$HOME/kde/lib:$LD_LIBRARY_PATH

# urlview(1) looks at BROWSER to determine what browser to open URLs in.
BROWSER=brave-browser

# Only run one ssh-agent at the same time.
if ! pgrep -u $USER ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-info
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval $(<~/.ssh-agent-info) >/dev/null
fi

# Aliases.

alias ip='ip -color=always'
alias ls='ls -s -h -F --color=auto --group-directories-first'
alias grep='grep -d skip --color=auto --binary-files=without-match'
alias fgrep='fgrep -d skip --color=auto --binary-files=without-match'
alias -- +='pushd +1'
alias -- -='pushd -0'
alias c='clear'
alias d=ls
alias h='history'
alias less='less -R'
alias ll='d -l'
alias lsalldir='=ls -ld */(D)'
alias lsd='ls -ld *(/)'
alias mt='multitail'
alias mutt='neomutt'
alias s='cd ..'
alias ss='cd ../..'
alias sss='cd ../../..'
alias todo="$EDITOR ~/doc/todo.md"
alias top=gotop
alias wlog="vim + ~/doc/wlog.md"
alias ec="$EDITOR $HOME/.zshrc"
alias sc="source $HOME/.zshrc"
alias vim="vim -X"

# Suffix aliases.  Launch files with a specific extension in a given program.

alias -s pdf=zathura
alias -s {md,go,c,py,txt}=vim
alias -s {png,jpg,jpeg}=eog

#zstyle ':completion:*' menu select yes
zstyle ':completion:*:default' list-colors ''

zstyle ':completion:*:descriptions' format $'%{\e[0;33m%}%d:%{\e[0m%}'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %P Lines: %m
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# process stuff
zstyle ':completion:*:processes'      command ps --forest -A -o pid,cmd
zstyle ':completion:*:processes'      list-colors '=(#b)( #[0-9]#)[^[/0-9a-zA-Z]#(*)=34=37;1=30;1'
zstyle ':completion:*:(pkill|kill):*' menu yes select
zstyle ':completion:*:kill:*'         force-list always

# Functions.

function meet {
	meeting_dir="${HOME}/doc/meeting"
	mkdir -p "$meeting_dir"
	d=`date -u '+%Y-%m-%d'`
	file="${meeting_dir}/${d}-${1}.md"
	vim "$file"
	echo "Edited $file"
}
