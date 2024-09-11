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
    inputs.sops-nix.homeManagerModules.sops
    outputs.homeManagerModules.core
    outputs.homeManagerModules.dev
    outputs.homeManagerModules.desktop
    outputs.homeManagerModules.ssh
  ];

  # sops = {
  #   defaultSopsFile = ../secrets/secrets.yaml;
  #   format = "yaml";
  # };

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
  targets.genericLinux.enable = true;
}
