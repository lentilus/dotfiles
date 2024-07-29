#!/bin/bash

nix-shell -p home-manager --run 'home-manager switch $HOME/dotfiles'
