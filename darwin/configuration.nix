{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
    service.nix-daemon.enable = true;
    nixpkgs.hostPlatform = "aarch64-darwin";
}
