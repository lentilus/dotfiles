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
  targets.genericLinux.enable = true;
}
