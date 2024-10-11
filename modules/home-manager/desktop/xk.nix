{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    xk.enable = lib.mkEnableOption "enable xettelkasten";
  };

  config = lib.mkIf config.xk.enable {
    home.packages = [
      pkgs.xk
    ];
  };
}
