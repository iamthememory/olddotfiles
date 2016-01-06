# This file is sourced by zsh for all shells.
# It cannot affect any input or output, and shouldn't assume that it's connected
# to a TTY.


# Set the PATH.


# In zsh, the PATH variable is tied to the path array.
# Force it to have unique values.
typeset -U path


# Local perl packages.
if [ -d "${HOME}/perl5/bin" ]
then
  path=("${HOME}/perl5/bin" "$path[@]")
fi

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
