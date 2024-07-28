#!/bin/bash

nix-shell -p home-manager --run 'home-manager switch --flake $HOME/dotfiles --impure'
