{ config, pkgs, userConfig, ... }:

    {
    imports = [
    ./modules/core/core.nix
    ./modules/dev/dev.nix
    ./modules/desktop/desktop.nix
    ];

  home.username = userConfig.name;
  home.homeDirectory = userConfig.home;

  # home-manager release
  home.stateVersion = "24.05"; # dont change?

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
    # devShells.${system}.default = pkgs.zsh;
    }
