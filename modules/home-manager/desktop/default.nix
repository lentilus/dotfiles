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
    ./xk.nix
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
    ];
    programs.zathura = {
      enable = true;
      options = {
        # sandbox = "none";
      };
    };

    browser.enable = lib.mkDefault true;
    mail.enable = lib.mkDefault true;
    pass.enable = lib.mkDefault true;
    sway.enable = lib.mkDefault true;
    stylix.enable = lib.mkDefault true;
    xk.enable = lib.mkDefault false;
  };
}
