{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.desktop.linux;
in {
  imports = [
    ./waybar
    ./mail
    ./hypr.nix
    ./mimetypes.nix
    ./stylix.nix
    ./packages.nix
    ./foot.nix
    ./rofi.nix
  ];

  options.desktop.linux = {
    enable = lib.mkEnableOption "enable all linux desktop modules";
  };

  config = lib.mkIf cfg.enable {
    # options
    stylix.enable = lib.mkDefault true;
    programs.zathura.enable = lib.mkDefault true;
    programs.mpv.enable = lib.mkDefault true;

    # cutom options
    desktop.linux = lib.mkDefault {
      mail.enable = true;
      waybar.enable = true;
      hypr.enable = true;
      mimeapps.enable = true;
    };
  };
}
