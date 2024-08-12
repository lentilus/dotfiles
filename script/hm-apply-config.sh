#!/bin/bash

# Install home manager configuration
nix build --extra-experimental-features "nix-command flakes" "../#homeConfigurations.${USER}.activationPackage"
./result/activate
