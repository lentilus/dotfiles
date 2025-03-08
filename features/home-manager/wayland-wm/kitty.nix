{lib, ...}: {
  home.sessionVariables.TERMINAL = lib.mkDefault "kitty";
  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };
  };
  stylix.targets.kitty.variant256Colors = true;
}
