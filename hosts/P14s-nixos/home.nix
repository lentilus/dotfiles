{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
    outputs.homeManagerModules.custom
  ];

  desktop = {
    enable = true;
    linux = {
      enable = true;
      hypr.enable = true;
    };
    yubikeyGpg = {
      enable = true;
      publicKeyPath = ./public-key.txt;
      pinentryPackage = pkgs.pinentry-rofi;
    };
    passwordStore = {
      enable = true;
      storePath = "${config.home.homeDirectory}/git/pass";
    };
  };

  dev.enable = true;

  nix = {
    package = lib.mkDefault pkgs.unstable.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  xdg = {
    enable = true;
  };

  home.username = "lentilus";
  home.homeDirectory = "/home/lentilus";
}
