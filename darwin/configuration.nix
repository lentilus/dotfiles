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
}
