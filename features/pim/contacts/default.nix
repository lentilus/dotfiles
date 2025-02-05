{
  lib,
  config,
  pkgs,
  ...
}: {
    accounts.contact = {
      accounts = import ./accounts.nix;
      basePath = "Contacts";
    };
    programs = {
      khard.enable = true;
  };
}
