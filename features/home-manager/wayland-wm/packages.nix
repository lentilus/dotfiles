{pkgs, ...}: {
  home.packages = [
    pkgs.poppler_utils
    pkgs.zathura
    pkgs.anki
    pkgs.libreoffice
    pkgs.calibre
  ];
  programs.mpv.enable = true;
}
