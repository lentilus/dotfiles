{
  lib,
  config,
  pkgs,
  ...
}: let
  basePath = "Calendar";
in {
  accounts.calendar = {
    accounts = import ./accounts.nix;
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
}
