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

    # TODO:
    outputs.homeManagerModules.custom
  ];

  desktop = {
    enable = true;
    linux.enable = false;
    yubikeyGpg = {
      enable = true;
      publicKeyPath = ../P14s-nixos/public-key.txt;
      pinentryPackage = pkgs.pinentry_mac;
    };
  };

  dev.enable = true;

  # some silly alternative until hydra builds again
  programs.qutebrowser.package = lib.mkForce pkgs.hello;
  programs.foot.enable = false;
  programs.rofi.enable = false;

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
