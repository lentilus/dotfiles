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
  ];

  nixpkgs = {
    overlays = [
      inputs.nixgl.overlay
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  desktop.enable = true;
  dev.enable = true;

  nix = {
    package = pkgs.unstable.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  home.username = "lentilus";
  home.homeDirectory = "/home/lentilus";

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
}
