#!/bin/bash

# Install home manager configuration
nix build --extra-experimental-features "nix-command flakes" "../#homeConfigurations.default.activationPackage"
./result/activate
