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
  ];

  options.desktop = {
    enable = lib.mkEnableOption "enable all desktop modules";
  };

  config = lib.mkIf cfg.enable {
    desktop.linux.enable = lib.mkDefault false;
    # desktop.darwin.enable = lib.mkDefault false;
    desktop.browser.enable = lib.mkDefault true;
  };
}
