{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./sway.nix
    ./kanshi.nix
    ./waybar.nix
    ./stylix.nix
  ];

  options = {
    desktop.enable = lib.mkEnableOption "foo";
  };

  config = lib.mkIf config.desktop.enable {
    sway.enable = lib.mkDefault true;
    kanshi.enable = lib.mkDefault true;
    waybar.enable = lib.mkDefault true;
    stylix.enable = lib.mkDefault true;
  };
}
