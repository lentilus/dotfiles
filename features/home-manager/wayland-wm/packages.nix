{pkgs, ...}: {
  home.packages = [
    pkgs.poppler_utils
    pkgs.zathura
    pkgs.anki
    pkgs.zapzap
    pkgs.signal-desktop
  ];
  programs.mpv.enable = true;
}
