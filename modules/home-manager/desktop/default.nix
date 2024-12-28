{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./sway
    ./mail
    ./browser
    ./kanata.nix
    ./stylix.nix
    ./pass.nix
    ./mimetypes.nix
  ];

  options = {
    desktop.enable = lib.mkEnableOption "enable all desktop modules";
  };

  config = lib.mkIf config.desktop.enable {
    home.packages = [
      pkgs.poppler_utils
      pkgs.signal-desktop
      pkgs.firefox
      pkgs.typst
    ];

    programs.zathura.enable = true;

    browser.enable = lib.mkDefault true;
    mail.enable = lib.mkDefault true;
    pass.enable = lib.mkDefault true;
    sway.enable = lib.mkDefault true;
    stylix.enable = lib.mkDefault true;
    mimeapps.enable = lib.mkDefault false;
    homeRowMods.enable = lib.mkDefault true;
  };
}
