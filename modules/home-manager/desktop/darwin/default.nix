{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktop.darwin;
in {
  options.desktop.darwin = {
    enable = lib.mkEnableOption "Enable darwin desktop config";
  };
  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      extraConfig = ''
        hide_window_decorations yes
        macos_option_as_alt yes
      '';
    };
  };
}
