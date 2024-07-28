#!/bin/bash

nix-shell '<home-manager>' -A install 
home-manager switch --flake "$HOME"/dotfiles --impure
