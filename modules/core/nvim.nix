{ config, pkgs, dotfiles, ... }:

{
    home.packages = [
        # plugin dependencies
        pkgs.fd
        pkgs.ripgrep
        pkgs.cargo

        pkgs.neovim
    ];

    home.file = {
        "${config.xdg.configHome}/nvim".source = "${dotfiles}/nvim";
    };
}

