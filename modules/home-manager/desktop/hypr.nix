{
  config,
  pkgs,
  lib,
  sources,
  ...
}: {
  config = lib.mkIf config.hypr.enable {

  options = {
    hypr.enable = lib.mkEnableOption "enable sway desktop";
  };

  config = lib.mkIf config.hypr.enable {
    wayland.windowManager.hyperland = {
        enable = true;
    }
  };
}
