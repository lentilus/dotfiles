{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.desktop.linux.mimeapps;
in {
  options.desktop.linux.mimeapps = {
    enable = lib.mkEnableOption "enable mime type app association";
  };
  config = lib.mkIf cfg.enable {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = let
        nvim = "nvim.desktop";
        qutebrowser = "org.qutebrowser.qutebrowser.desktop";
        zathura = "org.pwmt.zathura-pdf-mupdf.desktop";
        mpv = "mpv.desktop";
      in {
        # nvim
        "text/plain" = nvim;
        "text/markdown" = nvim;
        "application/json" = nvim;
        "application/xml" = nvim;

        # qutebrowser
        "text/html" = qutebrowser;
        "x-scheme-handler/http" = qutebrowser;
        "x-scheme-handler/https" = qutebrowser;
        "x-scheme-handler/about" = qutebrowser;
        "x-scheme-handler/unknown" = qutebrowser;

        "application/pdf" = zathura;

        "image/png" = qutebrowser;
        "image/jpg" = qutebrowser;
        "image/jpeg" = qutebrowser;

        # mpv
        "video/mp4" = mpv;
        "video/mpeg" = mpv;
        "video/ogg" = mpv;
        "video/x-matroska" = mpv;
      };
      associations = {};
    };
  };
}
