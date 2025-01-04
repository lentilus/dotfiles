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

  # nixpkgs = {
  #   overlays = [
  #     inputs.nixgl.overlay
  #     outputs.overlays.modifications
  #     outputs.overlays.unstable-packages
  #   ];
  #   # Configure your nixpkgs instance
  #   config = {
  #     allowUnfree = true;
  #   };
  # };

  desktop = {
    enable = true;
    linux = {
      enable = true;
      hypr.enable = true;
    };
    yubikeyGpg = {
      enable = true;
      publicKeyPath = ../public-key.txt;
      pinentryPackage = pkgs.pinentry-rofi;
    };
    passwordStore = {
      enable = true;
      storePath = "${config.home.homeDirectory}/git/pass";
    };
  };

  # sway.enable = false;
  dev.enable = true;

  nix = {
    package = lib.mkDefault pkgs.unstable.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  home.username = "lentilus";
  home.homeDirectory = "/home/lentilus";

  programs.home-manager.enable = true;
  # targets.genericLinux.enable = true;
}
