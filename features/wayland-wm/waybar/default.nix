{
  lib,
  config,
  pkgs,
  ...
}: {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings.mainBar = import ./settings.nix {inherit pkgs;};
      style = import ./style.nix {inherit config;};
    };

    stylix.targets.waybar.enable = false;
}
