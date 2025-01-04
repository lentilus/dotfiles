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
    ./hypr.nix
    ./mail
    ./mimetypes.nix
    ./stylix.nix
    ./packages.nix
  ];

  options.desktop.linux = {
    enable = lib.mkEnableOption "enable all linux desktop modules";
  };

  config = lib.mkIf cfg.enable {
    # options
    stylix.enable = lib.mkDefault true;
    programs.zathura.enable = lib.mkDefault true;

    # cutom options
    desktop.linux = lib.mkDefault {
      mail.enable = true;
      waybar.enable = true;
      hypr.enable = true;
      mimeapps.enable = true;
    };
  };
}
