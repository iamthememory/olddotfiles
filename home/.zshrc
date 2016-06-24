# This file is sourced by zsh only for interactive shells.


# The system-wide zsh profile on many systems will overwrite our PATH for login
# shells.
# Re-source our local environment just in case.
# (We don't add duplicates in it anyway.)
source "${HOME}/.zshenv"

# On Arch, tell which package a missing command is in.
if [ -e "/usr/share/doc/pkgfile/command-not-found.zsh" ]
then
  source /usr/share/doc/pkgfile/command-not-found.zsh
fi

# Load homeshick.
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=("$HOME/.homesick/repos/homeshick/completions" $fpath)

# Update homeshick dotfiles.
homeshick refresh 2

# Load the completion scripts.
autoload -U compinit promptinit
compinit
promptinit
zstyle ':completion::complete:*' use-cache 1
setopt correctall
setopt autocd
setopt extendedglob
setopt extendedhistory
setopt kshglob
setopt pushdtohome
setopt nullglob

# Aliases.
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias grep='grep --colour=auto'
alias ls='ls --color=auto'
alias cp='cp --reflink=auto'

# Load antigen.
source ~/.homesick/repos/antigen/antigen.zsh

# Load antigen stuff.
antigen use oh-my-zsh
antigen bundle command-not-found
antigen bundle git
antigen bundle pip
antigen bundle docker
antigen bundle catimg
antigen bundle git-extras
antigen bundle git-flow-avh
antigen bundle nyan
antigen bundle pass
antigen bundle sudo
antigen bundle taskwarrior
antigen bundle web-search
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle nojhan/liquidprompt
antigen apply

# Automatically read the ansible vault password.

unsetopt autopushd

# Save pretty much all command history.
export EXTENDED_HISTORY=1
export HISTSIZE=1000000
export SAVEHIST=1000000
export SHARE_HISTORY=1
