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
    # ./calendar # TODO
    ./stylix.nix
    ./pass.nix
  ];

  options = {
    desktop.enable = lib.mkEnableOption "enable all desktop modules";
  };

  config = lib.mkIf config.desktop.enable {
    home.packages = [
      pkgs.poppler_utils
      pkgs.signal-desktop
      pkgs.zathura
    ];

    browser.enable = lib.mkDefault true;
    mail.enable = lib.mkDefault true;
    pass.enable = lib.mkDefault true;
    sway.enable = lib.mkDefault true;
    stylix.enable = lib.mkDefault true;
  };
}
