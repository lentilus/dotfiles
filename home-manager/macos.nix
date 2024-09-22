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

  # some silly alternative until hydra builds again
  programs.qutebrowser.package = pkgs.hello;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.home-manager.enable = true;
}
