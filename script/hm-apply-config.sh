#!/bin/bash

# Install home manager configuration
# impure needed to read $HOME and $USER
nix build --impure --extra-experimental-features "nix-command flakes" "../#homeConfigurations.default.activationPackage"
./result/activate
