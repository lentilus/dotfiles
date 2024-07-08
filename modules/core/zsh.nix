{ config, pkgs, dotfiles, ... }:

{
    home.packages = [
        pkgs.locale
        pkgs.glibcLocales
        pkgs.git
        pkgs.zsh
        pkgs.zoxide
    ];

    home.file = {
        "${config.xdg.configHome}/zsh".source = "${dotfiles}/zsh";
        ".zshenv".text = ''
        # move zsh config out of home
        ZDOTDIR="${config.xdg.configHome}/zsh"

        # normally added by nix installer
        if [ -e ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh ]; then
            . ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh;
        fi
        '';
    };
}

