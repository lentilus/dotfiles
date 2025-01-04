{pkgs, ...}: {
  home.packages = [
    pkgs.poppler_utils
    pkgs.signal-desktop
    pkgs.firefox
    pkgs.unstable.typst
  ];
}
