{ config, pkgs, dotfiles, ... }:

{
    home.packages = [
        # desktop dependencies
        pkgs.dunst
        pkgs.kanshi
        pkgs.waybar
        pkgs.autotiling

        pkgs.sway
    ];

    home.file = {
        # "${config.xdg.configHome}/zsh".source = "${dotfiles}/zsh";
    };
}

