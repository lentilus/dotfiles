#!/bin/bash

# change default shell to zsh
path="$( which zsh )"
sudo chsh -s "$path" "$USER"
