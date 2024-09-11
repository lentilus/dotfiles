{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
  };
}
