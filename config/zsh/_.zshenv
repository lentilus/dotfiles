# enforce XDG specification
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/scripts:$PATH"
# export PATH="$PATH:$HOME/.ghcup/bin"
typeset -U PATH

export LANGUAGE="C.UTF-8"
export LC_ALL="C.UTF-8"
# export PAGER="foo"
export EDITOR="nvim"
export BROWSER="qutebrowser"

# otherwise terminal waits 1s to check for escape sequence
export ESCDELAY=0

# export PASSWORD_STORE_DIR="$HOME/git/password-store"

# move zsh config out of home
ZDOTDIR="${XDG_CONFIG_HOME}/zsh"


# nix stuff
if [ -e ${HOME}/.nix-profile/etc/profile.d/nix.sh ]; then
    . ${HOME}/.nix-profile/etc/profile.d/nix.sh;
fi

# home manager variables
if [ -e ${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
    . ${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

