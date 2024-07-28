#!/bin/bash

nix-shell --extra-experimental-features nix-command -p home-manager --run 'home-manager switch --flake $HOME/dotfiles --impure'
