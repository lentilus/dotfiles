{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./sway
    # ./sway.nix
    # ./kanshi.nix
    # ./waybar.nix
    ./stylix.nix
    ./mail.nix
    ./qutebrowser.nix
  ];

  options = {
    desktop.enable = lib.mkEnableOption "desktop configuration";
  };

  config = lib.mkIf config.desktop.enable {
    home.packages = [
      pkgs.poppler_utils
      pkgs.signal-desktop
    ];

    browser.enable = lib.mkDefault true;
    mail.enable = lib.mkDefault true;
    sway.enable = lib.mkDefault true;
    stylix.enable = lib.mkDefault true;
  };
}
