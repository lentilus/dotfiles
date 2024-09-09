{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
    nixpkgs.hostPlatform = "aarch64-darwin";
}
