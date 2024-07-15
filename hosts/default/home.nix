{
  config,
  pkgs,
  ...
} @ inputs: {
  imports = [
    ../../home-manager/core/core.nix
    ../../home-manager/dev/dev.nix
    ../../home-manager/desktop/desktop.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.05"; # dont just change
}
