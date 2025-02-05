{
  lib,
  config,
  pkgs,
  ...
}: {
    programs.kitty = {
      enable = true;
      extraConfig = ''
        hide_window_decorations yes
        macos_option_as_alt yes
      '';
    };
}
