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
    outputs.homeManagerModules
    ../../features/cli
    ../../features/browser
    ../../features/pim
    ../../features/wayland-wm
  ];

  ### custom options ###
  yubikey = {
    enable = true;
    publicKeyPath = ./public-key.txt;
    sshKeygrip = "0C5B390F0ECDC5446622AE31F0916A3588C5B284";
    pinentryPackage = pkgs.pinentry-rofi;
  };
  passwordstore = {
    enable = true;
    storePath = "${config.home.homeDirectory}/git/pass";
  };
  ### custom options END ###

  nix = {
    package = lib.mkDefault pkgs.unstable.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  xdg.enable = true;

  home = {
    username = "lentilus";
    homeDirectory = "/home/lentilus";
    stateVersion = "24.05";
  };
}
