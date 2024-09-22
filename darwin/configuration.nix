{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.nix-daemon.enable = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  services.skhd = {
    enable = true;
    skhdConfig = ''
      cmd + a : open -n -a "kitty"
      cmd + s : open -n -a "qutebrowser"
    '';
  };
}
