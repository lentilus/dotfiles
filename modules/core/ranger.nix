{ config, pkgs, dotfiles, ... }:

{
    home.packages = [
        pkgs.ranger
    ];

    home.file = {
        "${config.xdg.configHome}/ranger".source = "${dotfiles}/ranger";
    };
}

