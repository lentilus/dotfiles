{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktop.linux.contacts;
in {
  options.desktop.linux.contacts = {
    enable = lib.mkEnableOption "enable contacts config";
  };

  config = lib.mkIf cfg.enable {
    accounts.contact = {
      accounts = (import ./accounts.nix) pkgs;
      basePath = "Contacts";
    };
    programs = {
      khard.enable = true;
    };
  };
}
