{
  config,
  pkgs,
  lib,
  sources,
  ...
}: {
  options = {
    hypr.enable = lib.mkEnableOption "enable sway desktop";
  };

  config = lib.mkIf config.hypr.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings.main.term = "xterm-256color";
    };

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };

    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };

    wayland.windowManager.hyprland = let
      startup = pkgs.pkgs.writeShellScriptBin "start" ''
        # ${pkgs.waybar}/bin/waybar &
        notify-send "Hello from autostart!"
      '';
    in {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        exec-once = "${startup}/bin/start";
        misc.disable_hyprland_logo = true;
        input.touchpad.natural_scroll = true;
        windowrulev2 = "suppressevent maximize, class:.*";
        bind = [
          # controls
          "$mod, q, killactive"
          "$mod Shift, Q, exit"
          "$mod, Tab, fullscreen"

          # move focus
          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"

          # utils
          "$mod, Space, exec, ${config.programs.rofi.package}/bin/rofi -show drun"

          # apps
          "$mod, Return, exec, ${pkgs.foot}/bin/footclient"
        ];
      };
    };
  };
}
