{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktop.linux.waybar;
in {
  options.desktop.linux.waybar = {
    enable = lib.mkEnableOption "Enable Waybar configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = false; # not working with uwsm

      settings.mainBar = import ./settings.nix {inherit pkgs;};
      style = import ./style.nix {inherit config;};
    };
  };
}
