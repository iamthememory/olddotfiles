# This file is sourced by zsh for all shells.
# It cannot affect any input or output, and shouldn't assume that it's connected
# to a TTY.


# Always dump core.
ulimit -c unlimited

# Create local perl and TeX directories.
mkdir -p "${HOME}/"{perl5,texmf} >/dev/null 2>&1


# Environment variables.


# Use vim as the default editor.
if command -v vim >/dev/null 2>&1
then
  export EDITOR="$(which vim)"
fi

# Save pretty much all command history.
export EXTENDED_HISTORY=1
export HISTSIZE=1000000
export SAVEHIST=1000000
export SHARE_HISTORY=1

# Use color in less.
export LESSCOLOR="yes"

# Connect to system qemu libvirtd by default.
export LIBVIRT_DEFAULT_URI="qemu:///system"

# Set local perl package install options.
export PERL_MB_OPT="--install_base \"${HOME}/perl5\""
export PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"

# The interactive Python startup file.
export PYTHONSTARTUP="${HOME}/.pythonrc.py"

# Use st as the terminal.
if command -v st >/dev/null 2>&1
then
  export TERMINAL="st"
fi

# Local TeX packages.
export TEXMFHOME="${HOME}/texmf"

# Use 32-bit wine.
export WINEARCH="win32"

# Use i3 as the window manager (if it exists).
if [ -e "/etc/X11/Sessions/i3wm" ]
then
  export XSESSION="i3wm"
fi

# Proxy git through tor (if possible).
if [ -e "${HOME}/.local/bin/tor-socks-proxy.sh" ]
then
  export GIT_PROXY_COMMAND="${HOME}/.local/bin/tor-socks-proxy.sh"
fi

# Load the ssh and gpg agent variables from keychain.
if [ -e "${HOME}/.keychain/load-keychain" ]
then
  [ -z "${HOSTNAME}" ] && HOSTNAME="$(uname -n)"
  [ -f "${HOME}/.keychain/${HOSTNAME}-sh" ] && source "${HOME}/.keychain/${HOSTNAME}-sh"
  [ -f "${HOME}/.keychain/${HOSTNAME}-sh-gpg" ] && source "${HOME}/.keychain/${HOSTNAME}-sh-gpg"
fi


# Set the PATH-like variables.


# Tie arrays to the PATH-like, colon-separated variables.
typeset -T CLASSPATH classpath
typeset -T GOPATH gopath
typeset -T LS_COLORS ls_colors
typeset -T PERL5LIB perl5lib
typeset -T PERL_LOCAL_LIB_ROOT perl_local_lib_root

# Note that PATH and MANPATH already have tied arrays by default.


# Set the CLASSPATH.


if [ -e "/usr/share/junit/lib/junit.jar" ]
then
  classpath+=("/usr/share/junit/lib/junit.jar")
fi


# Set the GOPATH.


gopath=("${HOME}/.local/go")


# Set the LS_COLORS.


ls_colors+=("*.green=04;32")


# Set the MANPATH.


# Add local manpages.
for mandir in "${HOME}/.local/"{share/,}"man"
do
  if [ -d "${mandir}" ]
  then
    manpath=("${mandir}" "$manpath[@]")
  fi
done


# Set the PATH.


# Go binaries.
path=("${HOME}/.local/go/bin" "$path[@]")

# Local perl packages.
path=("${HOME}/perl5/bin" "$path[@]")

# Add any ruby gems to the PATH.
if command -v ruby >/dev/null 2>&1
then
  export GEM_HOME="$(ruby -e 'print Gem.user_dir')"
  export GEM_PATH="${GEM_HOME}"
  path=("${GEM_HOME}/bin" "$path[@]")
fi

# Local programs and scripts.
path=("${HOME}/.local/bin" "$path[@]")

# Add general system directories (just in case).
for d in /usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin
do
  path+=("$d")
done

# FSlint utilities.
if [ -d "/usr/share/fslint/fslint" ]
then
  path+=("/usr/share/fslint/fslint")
fi


# Set the PERL5LIB.


perl5lib=("${HOME}/perl5/lib/perl5" "$perl5lib[@]")


# TeX Live perl stuff.

if [ -d "/usr/share/tlpkg" ]
then
  perl5lib=("/usr/share/tlpkg" "$perl5lib[@]")
fi

if [ -d "/usr/share/texmf-dist/scripts/texlive" ]
then
  perl5lib=("/usr/share/texmf-dist/scripts/texlive" "$perl5lib[@]")
fi


# Set the PERL_LOCAL_LIB_ROOT.


perl_local_lib_root=("${HOME}/perl5" "$perl_local_lib_root[@]")


# Force the variables tied to arrays to have unique elements.
typeset -U classpath
typeset -U gopath
typeset -U ls_colors
typeset -U manpath
typeset -U path
typeset -U perl5lib
typeset -U perl_local_lib_root
