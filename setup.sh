#!/bin/bash


# install home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# nix-env -iA nixpkgs.home-manager


# nixconf=$PWD/nixbuildconf/nix.conf
# echo "experimental-features = nix-command flakes" > $nixconf
# NIX_CONF_DIR=$nixconf; nix-shell -p home-manager 'home-manager switch --flake "$HOME"/dotfiles --impure'
