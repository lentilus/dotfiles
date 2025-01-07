{pkgs, lib, config, ...}: {
  home.packages = lib.mkIf config.desktop.linux.enable [
    pkgs.poppler_utils
    pkgs.signal-desktop
    pkgs.firefox
    pkgs.unstable.typst
  ];
}
