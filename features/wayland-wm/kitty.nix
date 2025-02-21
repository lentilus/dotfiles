{lib, ...}: {
  home.sessionVariables.TERMINAL = lib.mkDefault "kitty";
  programs.kitty = {
    enable = true;
    settings.enable_audio_bell=false;
  };
  stylix.targets.kitty.variant256Colors = true;
}
