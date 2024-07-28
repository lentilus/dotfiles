{
  config,
  lib,
  pkgs,
  ...
} @ inputs: {
  imports = [
    # things I need everywhere without exception
    # -> shell, tmux, nvim, ranger
    ../../home-manager/core/core.nix

    # development stuff
    # -> git, pyenv, poetry, etc
    ../../home-manager/dev/dev.nix

    # my sway desktop
    ../../home-manager/desktop/desktop.nix
  ];

  desktop.enable = lib.mkDefault false;
  dev.enable = lib.mkDefault false;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.05"; # dont just change
}
