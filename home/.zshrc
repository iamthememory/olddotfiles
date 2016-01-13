# This file is sourced by zsh only for interactive shells.


# The system-wide zsh profile on many systems will overwrite our PATH for login
# shells.
# Re-source our local environment just in case.
# (We don't add duplicates in it anyway.)
source "${HOME}/.zshenv"


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

# Load antigen.
source ~/.antigenrepo/antigen.zsh

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
antigen bundle autojump
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle nojhan/liquidprompt
antigen bundle iamthememory/homesick-zsh-completion
antigen apply

# Automatically read the ansible vault password.
alias ansible-playbook='ansible-playbook --vault-password-file ~/.ansible.vaultpass.sh'
alias ansible='ansible --vault-password-file ~/.ansible.vaultpass.sh'

# Use keychain to load ssh and GPG keys.
if [ -e "${HOME}/.keychain/load-keychain" ]
then
  (
    echo ~/.ssh/*id_rsa
    if command -v gpg >/dev/null 2>&1
    then
      gpg --list-secret-keys --with-colons |
        grep '^sec' |
        cut -d : -f 5 |
        sed 's/^.*$/0x&/'
    fi
  ) |
    xargs keychain --agents ssh,gpg
  [ -z "${HOSTNAME}" ] && HOSTNAME="$(uname -n)"
  [ -f "${HOME}/.keychain/${HOSTNAME}-sh" ] && source "${HOME}/.keychain/${HOSTNAME}-sh"
  [ -f "${HOME}/.keychain/${HOSTNAME}-sh-gpg" ] && source "${HOME}/.keychain/${HOSTNAME}-sh-gpg"
fi

unsetopt autopushd

# Save pretty much all command history.
export EXTENDED_HISTORY=1
export HISTSIZE=1000000
export SAVEHIST=1000000
export SHARE_HISTORY=1
