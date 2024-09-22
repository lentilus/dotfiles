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
    inputs.mac-app-util.homeManagerModules.default
    outputs.homeManagerModules.core
    outputs.homeManagerModules.dev
    outputs.homeManagerModules.desktop
    outputs.homeManagerModules.darwinDesktop
  ];

  desktop.enable = false;
  dev.enable = true;
  stylix.enable = true;

  browser.enable = true;

  # just provide some silly alternative i.e. hello
  programs.qutebrowser.package = pkgs.hello;
  home.packages = [
    # pkgs.rofi
  ];

  nixpkgs = {
    # overlays = [
    #   inputs.nixgl.overlay
    #   (final: prev: {qutebrowser = prev.qutebrowser.override {enableWideVine = true;};})
    # ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  # nix = {
  #   package = pkgs.nix;
  #   settings.experimental-features = ["nix-command" "flakes"];
  # };

  # home.username = "linuspreusser";
  # home.homeDirectory = "/Users/linuspreusser";

  programs.home-manager.enable = true;
  home.stateVersion = "24.05"; # dont just change
}
