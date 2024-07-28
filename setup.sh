#!/bin/bash

nix-env -iA nixpkgs.home-manager


# nixconf=$PWD/nixbuildconf/nix.conf
# echo "experimental-features = nix-command flakes" > $nixconf
# NIX_CONF_DIR=$nixconf; nix-shell -p home-manager 'home-manager switch --flake "$HOME"/dotfiles --impure'
