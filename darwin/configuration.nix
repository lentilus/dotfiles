{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
    imports = [
        inputs.mac-app-util.homeManagerModules.default
    ];
  services.nix-daemon.enable = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
