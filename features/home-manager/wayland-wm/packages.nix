{pkgs, ...}: {
  home.packages = [
    pkgs.poppler_utils
    pkgs.zathura
    pkgs.anki
    pkgs.libreoffice

    # communication
    pkgs.zapzap
    pkgs.signal-desktop
    pkgs.telegram-desktop
  ];
  programs.mpv.enable = true;
}
