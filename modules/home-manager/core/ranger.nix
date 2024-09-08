{
  config,
  pkgs,
  lib,
  outputs,
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
        source = "${outputs.sources.dotfiles}/ranger";
        recursive = true;
      };
    };
  };
}
