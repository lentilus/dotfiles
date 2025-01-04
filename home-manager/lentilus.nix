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
    outputs.homeManagerModules.core
    outputs.homeManagerModules.dev
    outputs.homeManagerModules.desktop
    outputs.homeManagerModules.ssh
    outputs.homeManagerModules.homeConfig
    outputs.homeManagerModules.yubikeyGpg
    outputs.homeManagerModules.passwordStore
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

  desktop.enable = true;
  # sway.enable = false;
  dev.enable = true;

  yubikeyGpg = {
    enable = true;
    publicKeyPath = ../public-key.txt;
    pinentryPackage = pkgs.pinentry-rofi;
  };

  passwordStore = {
    enable = true;
    storePath = "${config.home.homeDirectory}/git/pass";
  };

    
  nix = {
    package = lib.mkDefault pkgs.unstable.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  home.username = "lentilus";
  home.homeDirectory = "/home/lentilus";

  programs.home-manager.enable = true;
  # targets.genericLinux.enable = true;

}
