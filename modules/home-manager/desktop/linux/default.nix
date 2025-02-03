{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.desktop.linux;
in {
  imports = [
    ./mail
    ./calendar
    ./contacts
    ./waybar
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
    services.dunst.enable = true;
    programs.zathura.enable = lib.mkDefault true;
    programs.mpv.enable = lib.mkDefault true;

    # cutom options
    desktop.linux = lib.mkDefault {
      mail.enable = true;
      calendar.enable = true;
      contacts.enable = true;
      waybar.enable = true;
      hypr.enable = true;
      mimeapps.enable = true;
    };
  };
}
