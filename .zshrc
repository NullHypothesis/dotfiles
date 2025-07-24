# Where to store the shell history.
HISTFILE=~/.history

# Size of the shell history.
SAVEHIST=10000

# Save the timestamp and duration of a command.
setopt extended_history

# Don't add commands to the history if they are duplicates of the previous command.
setopt hist_ignore_dups

# If the history needs to be trimmed, expire duplicates first.
setopt hist_expire_dups_first

# When searching the history, don't display results that were already cycled through.
setopt hist_find_no_dups

# Remove unnecessary whitespace before adding a command to the history.
setopt hist_reduce_blanks

# When exiting, the shell appends its history rather than replacing it.
setopt append_history

# Try to make the completion list smaller.
setopt list_packed

# Allow the short forms of certain constructs.
setopt short_loops

zstyle :compinstall filename '~/.zshrc'

# This is necessary to make ctrl+left/right work in combination with urxvt.
bindkey "\eOc"    forward-word
bindkey "\eOd"    backward-word
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[5C"   forward-word
bindkey "\e[5D"   backward-word
bindkey "\e\e[C"  forward-word
bindkey "\e\e[D"  backward-word

dir_colors="~/.dir_colors"
if test -e "$dir_colors"; then
	eval `dircolors "$dir_colors"`
fi

autoload -Uz compinit && compinit
# Enable case insensitive tab completion, e.g., for completing directories.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

autoload -U colors && colors

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
precmd() {
    vcs_info
}

# Format the vcs_info_msg_0_ variable
#zstyle ':vcs_info:git:*' formats 'on branch %b'

BRANCH=$'\uE0A0'

zstyle ':vcs_info:git*' formats " %{$fg[blue]%}(%{$fg[cyan]%}%b%{$reset_color%}%m%u%c%{$reset_color%}%{$fg[blue]%})"
zstyle ':vcs_info:git*' actionformats "%s  %r/%S %b %m%u%c "

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST

# What the shell prompt looks like.
# Line 1: Username (%n)
# Line 2: Current directory (relative, or absolute)
# Line 3: Shell prompt ($ in case of a 0 return code)
# Line 4: Shell prompt (NUM in case of a non-0 return code)
PROMPT=\
$'%{$fg[blue]%}%n'\
$' %{$fg[default]%}%0(5c,…/%c,%~)'\
$'%{$fg[red]%}%{$fg[blue]%}%0(?,%{$fg[blue]%}'\
$'${vcs_info_msg_0_} »,'\
$'%{$fg[red]%} %?%{$fg[blue]%} $%s)%b '


####
# Tab Completion

ZLS_COLORS=$LS_COLORS

unset GPG_AGENT_INFO

export GOPATH=$HOME/go
export GOBIN=${GOPATH}/bin
# Disable annoying TileDB deprecation warnings when running tests.
export CGO_CPPFLAGS="-Wno-deprecated-declarations"

export HOSTNAME="`hostname`"
export EDITOR=vim
export VISUAL="${EDITOR}"
export MAIL=$HOME/mail/sysmail
export PAGER=less

export PATH=$PATH:/home/${USER}/.local/bin
export PATH=$PATH:/home/${USER}/bin
export PATH=$GOBIN:$PATH
if [ "`uname -s`" = "Darwin" ]; then
	export PATH=$PATH:/opt/homebrew/bin/
fi

export LESS='--ignore-case'
export LESS_TERMCAP_md=$'\E[1;31m' # Begin blink (bright red).
export LESS_TERMCAP_me=$'\E[0m'    # Reset bold/blink.
export LESS_TERMCAP_us=$'\E[32m'   # Begin underline (green).
export LESS_TERMCAP_ue=$'\E[0m'    # Reset underline.

export QA_USR="philipp"
export QA_PWD="xbg2uyt4TDX-wzk-kqw"

# TERMINAL is for i3 to figure out which is our default terminal.
export TERMINAL=urxvt

export GREP_OPTIONS='--color=auto --binary-files=without-match'
export GREP_COLOR='3;33'

export DYLD_FALLBACK_LIBRARY_PATH=/usr/local/lib

# Only run one ssh-agent at the same time.
if ! pgrep -u $USER ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-info
fi
if [[ "$SSH_AGENT_PID" == "" && -e ~/.ssh-agent-info ]]; then
    eval $(<~/.ssh-agent-info) >/dev/null
fi

# Unconditional aliases.
alias ip='ip -color=always'
alias ls='ls -FG1'
alias ll='ls -lh'
alias lsd='ls -ld *(/)'
alias mutt='neomutt'
alias .='cd ..'
alias ..='cd ../..'
alias ...='cd ../../..'
alias test-e2e='go test -v -exec "env DYLD_LIBRARY_PATH=/usr/local/lib" github.com/TileDB-Inc/TileDB-Server/cmd/services/api/end2end_tests'
alias test-e2e-silent='go test -exec "env DYLD_LIBRARY_PATH=/usr/local/lib" github.com/TileDB-Inc/TileDB-Server/cmd/services/api/end2end_tests'
alias gotest='go test -exec "env DYLD_LIBRARY_PATH=/usr/local/lib"'

# Conditional aliases.
if command -v gotop 2>&1 >/dev/null; then
	alias top=gotop
fi

if command -v fzf 2>&1 >/dev/null; then
	source <(fzf --zsh)
fi
