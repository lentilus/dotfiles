{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.hypr.enable {
    stylix.targets.waybar.enable = false;
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings.mainBar = import ./settings.nix {inherit pkgs;};
      style = import ./style.nix {inherit config;};
    };
  };
}
