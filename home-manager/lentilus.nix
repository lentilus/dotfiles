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
  ];

  nixpkgs = {
    overlays = [
      inputs.nixgl.overlay
      (final: prev: {qutebrowser = prev.qutebrowser.override {enableWideVine = true;};})
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  desktop.enable = true;
  dev.enable = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  home.username = "lentilus";
  home.homeDirectory = "/home/lentilus";

  programs.home-manager.enable = true;
  home.stateVersion = "24.05"; # dont just change
}
