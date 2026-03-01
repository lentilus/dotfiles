{pkgs, ...}: {
  home.packages = [
    # pkgs.poppler_utils
    pkgs.anki
    pkgs.libreoffice
    pkgs.calibre
    pkgs.passes # display pkpass files
    pkgs.unstable.spotdl
    pkgs.archive-mail
    pkgs.pgpmime-decrypt
  ];
}
