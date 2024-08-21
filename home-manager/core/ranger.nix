{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    ranger.enable = lib.mkEnableOption "foo";
  };

  config = lib.mkIf config.ranger.enable {
    home.packages = [
      pkgs.ranger
    ];

    home.file = {
      "${config.xdg.configHome}/ranger" = {
        source = ../../config/ranger;
        recursive = true;
      };
    };
  };
}
