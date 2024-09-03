# sourced after .zshenv but before .zshrc

emulate sh
. ~/.profile
emulate zsh

# if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
#     # start ssh-agent
#     # eval $(ssh-agent -s)
#     # trap 'kill $SSH_AGENT_PID' EXIT
#
#     # start gpg-agent
#     # eval $(gpg-agent -s)
#
#     exec nixGLIntel sway
# fi
