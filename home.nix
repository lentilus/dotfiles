{
  config,
  pkgs,
  userConfig,
  ...
}: {
  imports = [
    ./modules/core/core.nix
    ./modules/dev/dev.nix
    ./modules/desktop/desktop.nix
  ];

  home.username = userConfig.name;
  home.homeDirectory = userConfig.home;

  home.stateVersion = "23.11"; # dont change

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  programs.home-manager.enable = true;
}
