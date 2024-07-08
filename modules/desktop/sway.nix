{ config, pkgs, dotfiles, ... }:

{
    home.packages = [
        # desktop dependencies
        pkgs.nixgl.auto.nixGLDefault
        pkgs.dunst
        pkgs.kanshi
        pkgs.waybar
        pkgs.autotiling
        pkgs.rofi
        pkgs.sway
        pkgs.foot
    ];

    home.file = {
        "${config.xdg.configHome}/sway".source = "${dotfiles}/sway";
        "${config.xdg.configHome}/waybar".source = "${dotfiles}/waybar";
        "${config.xdg.configHome}/rofi".source = "${dotfiles}/rofi";
    };
}

