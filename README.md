# lentilus dotfiles

This repository includes my entire working-environment managed in a
`nix flake` with the help of `nixos` and `home-manager`.
For secrets management I use `sops` with `sops-nix`.

Using the power of `proot` my shell environment can be temporarily used on
any machine that has nix installed by running the following.
```nix
HOME=/tmp/my-tmp-home nix run github:lentilus/dotfiles#shell --impure -- zsh
```
In fact, you can safely try that on your own machine. You can
look at `./proot-shell.nix` to see what it does.

