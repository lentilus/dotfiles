{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.hypr.enable {
    programs.waybar.systemd = {
      enable = true;
      target = "sway-session.target";
    };
    stylix.targets.waybar.enable = false;
    programs.waybar = {
      enable = true;

      settings.mainBar = import ./settings.nix;
      style = import ./style.nix;
    };
  };
}
