{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktop.linux.calendar;
  basePath = "Calendar";
in {
  options.desktop.linux.calendar = {
    enable = lib.mkEnableOption "enable calendar config";
  };

  config = lib.mkIf cfg.enable {
    accounts.calendar = {
      accounts = (import ./accounts.nix) pkgs;
      basePath = basePath;
    };
    programs = {
      vdirsyncer.enable = true;
      khal.enable = true;
      todoman = {
        enable = true;
        extraConfig = ''
          path = "~/${basePath}/*"
          default_list = "personal";
        '';
      };
    };
    services.vdirsyncer = {
      enable = true;
      frequency = "*:0/15";
    };
  };
}
