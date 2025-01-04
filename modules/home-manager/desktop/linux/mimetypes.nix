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
      associations.added = {
        "application/pdf" = ["zathura.desktop"];
      };
      defaultApplications = {
        "application/pdf" = ["zathura.desktop"];
      };
    };
  };
}
