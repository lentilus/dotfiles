{lib, ...}: {
  home.sessionVariables = {
    TERMINAL = lib.mkDefault "footclient";
  };
  programs.foot = lib.mkDefault {
    enable = true;
    server.enable = false; # not working with uwsm
    settings.main.term = "xterm-256color";
  };
}
