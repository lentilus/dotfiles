{lib, ...}: {
  home.sessionVariables = {
    TERMINAL = lib.mkDefault "footclient";
  };
  programs.foot = lib.mkDefault {
    enable = true;
    server.enable = true;
    settings.main.term = "xterm-256color";
  };
}
