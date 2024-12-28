{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    mimeapps.enable = lib.mkEnableOption "enable mime type app association";
  };
  config = lib.mkIf config.mimeapps.enable {
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
