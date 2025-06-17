{
  lib,
  pkgs,
  ...
}: {
  home.sessionVariables.TERMINAL = lib.mkDefault "kitty";
  programs.kitty = {
    enable = true;
    package = pkgs.unstable.kitty;
    settings = {
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      text_fg_override_threshold = "4.5 ratio";
    };
  };
  stylix.targets.kitty.variant256Colors = true;
}
