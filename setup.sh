#!/bin/bash

echo "experimental-features = nix-command flakes" > /etc/nix/nix.conf
nix-shell -p home-manager 'home-manager switch --flake "$HOME"/dotfiles --impure'
