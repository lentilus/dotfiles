{
  lib,
  pkgs,
  ...
}: {
  programs.rofi = lib.mkDefault {
    enable = true;
    package = pkgs.rofi-wayland;
  };
}
