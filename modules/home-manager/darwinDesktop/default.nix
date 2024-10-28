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
      macos_option_as_alt yes
    '';
    enable = true;
  };
}
