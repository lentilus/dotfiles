#!/bin/bash

nix-env -iA home-manager
home-manager switch --flake "$HOME"/dotfiles --impure
