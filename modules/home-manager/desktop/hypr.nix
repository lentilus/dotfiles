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

      workspaceBindings = builtins.map (name: "$mod, ${name}, workspace, ${name}") [ "1" "2" "3" "4" ];
      moveWorspaceBindings = builtins.map (name: "$mod Shift, ${name}, movetoworkspace, ${name}") [ "1" "2" "3" "4" ];
    in {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        exec-once = "${startup}/bin/start";
        misc.disable_hyprland_logo = true;
        input.touchpad.natural_scroll = true;
        windowrulev2 = "suppressevent maximize, class:.*";
        animation = "global, 1, 2, default";
        bind = lib.concatLists [
          [
            # controls
            "$mod, q, killactive"
            "$mod Shift, Q, exit"
            "$mod, Tab, fullscreen"

            # move focus
            "$mod, H, movefocus, l"
            "$mod, J, movefocus, d"
            "$mod, K, movefocus, u"
            "$mod, L, movefocus, r"

            # move window
            "$mod Shift, H, movewindow, l"
            "$mod Shift, J, movewindow, d"
            "$mod Shift, K, movewindow, u"
            "$mod Shift, L, movewindow, r"

            # utils
            "$mod, Space, exec, ${config.programs.rofi.package}/bin/rofi -show drun"
            "$mod, x, exec, ${config.programs.rofi.pass.package}/bin/rofi-pass"

            # apps
            "$mod, Return, exec, ${pkgs.foot}/bin/footclient"
          ]
          workspaceBindings
          moveWorspaceBindings
        ];
      };
    };
  };
}

