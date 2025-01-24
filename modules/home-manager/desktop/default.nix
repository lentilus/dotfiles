{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.desktop;
in {
  imports = [
    ./linux
    ./darwin
    ./browser
    ./passwordStore.nix
    ./yubikeyGpg.nix
  ];

  options.desktop = {
    enable = lib.mkEnableOption "enable all desktop modules";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
    };
    desktop.linux.enable = lib.mkDefault false;
    # desktop.darwin.enable = lib.mkDefault false;
    desktop.browser.enable = lib.mkDefault true;
  };
}
