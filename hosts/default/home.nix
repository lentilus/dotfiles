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

  home.username = inputs.userConfig.name;
  home.homeDirectory = inputs.userConfig.home;

  home.stateVersion = "23.11"; # dont change

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  programs.home-manager.enable = true;
}
