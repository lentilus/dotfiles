{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.greeting;
in {
  options.custom.greeting = {
    enable = lib.mkEnableOption "start hyprland via uwsm on tty1-login";
  };
  config = lib.mkIf cfg.enable {
    services.dbus.enable = true;

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          # we execute with zsh so the sway process has the hm env
          command = "${pkgs.zsh}/bin/zsh -c ${pkgs.sway}/bin/sway";
          user = "lentilus";
        };
        default_session = initial_session;
      };
    };
  };
}
