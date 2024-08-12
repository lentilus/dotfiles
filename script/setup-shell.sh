#!/bin/bash

# change default shell to zsh
path="$( which zsh )"
chsh -s "$path" "$USER"
