{ config, pkgs, ... }:

{
    home.packages = [
        pkgs.poetry
        pkgs.fzf
        pkgs.git
        (pkgs.nerdfonts.override { fonts = ["JetBrainsMono"]; })
    ];
}
