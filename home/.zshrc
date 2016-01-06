# Load the Gentoo completion scripts.
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

# Command history.
export EXTENDED_HISTORY=1
export HISTSIZE=1000000
export SAVEHIST=1000000
export SHARE_HISTORY=1

# Use i3
export XSESSION="i3wm"

# Use st as the terminal
export TERMINAL="st"

# Always dump core
ulimit -c unlimited

# Connect to system qemu libvirtd by default
export LIBVIRT_DEFAULT_URI="qemu:///system"

# 32-bit wine
export WINEARCH="win32"

# Add more colors to ls.
export LS_COLORS="$LS_COLORS:*.green=04;32"

# Default editor is vim
export EDITOR="$(which vim)"

# Python startup file
export PYTHONSTARTUP="${HOME}/.pythonrc.py"

# Proxy git through tor
export GIT_PROXY_COMMAND="${HOME}/.local/bin/tor-socks-proxy.sh"

# FSlint utilities
if [ -d "/usr/share/fslint/fslint" ]
then
  export PATH="${PATH}:/usr/share/fslint/fslint"
fi

# Local programs and scripts.
export PATH="${HOME}/.local/bin:${PATH}"

# Add any ruby gems to the PATH.
if command -v ruby >/dev/null 2>&1
then
  export GEM_HOME="$(ruby -e 'print Gem.user_dir')"
  export GEM_PATH="${GEM_HOME}"
  export PATH="${GEM_HOME}/bin:${PATH}"
fi

# Add sbins
export PATH="${PATH}:/usr/local/sbin:/usr/sbin:/sbin"

# Add local manpages.
for mandir in "${HOME}/.local/"{share/,}"man"
do
  if [ -d "${mandir}" ]
  then
    export MANPATH="${mandir}:${MANPATH}"
  fi
done

# Set the default path for Go.
export GOPATH="${HOME}/.local/go"
export GOBIN="${HOME}/.local/bin"

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

if [ -d /usr/share/tlpkg ]
then
  export PERL5LIB="/usr/share/tlpkg${PERL5LIB+:}${PERL5LIB}"
fi

if [ -d /usr/share/texmf-dist/scripts/texlive ]
then
  export PERL5LIB="/usr/share/texmf-dist/scripts/texlive${PERL5LIB+:}${PERL5LIB}"
fi

mkdir -p "${HOME}/perl5"
export PATH="${HOME}/perl5/bin${PATH+:}${PATH}"
export PERL5LIB="${HOME}/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"
export PERL_LOCAL_LIB_ROOT="${HOME}/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"
export PERL_MB_OPT="--install_base \"${HOME}/perl5\""
export PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"

mkdir -p "${HOME}/texmf"
export TEXMFHOME="${HOME}/texmf"

if [ -e "/usr/share/junit/lib/junit.jar" ]
then
  export CLASSPATH="${CLASSPATH}:/usr/share/junit/lib/junit.jar"
fi

export LESSCOLOR="yes"

unsetopt autopushd
