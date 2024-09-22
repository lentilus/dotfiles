{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    extraConfig = ''
      hide_window_decorations yes
    '';
    enable = true;
  };
}
