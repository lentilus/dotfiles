{
  config,
  pkgs,
  lib,
  sources,
  ...
}: let
  cfg = config.desktop.linux.hypr;
in {
  options.desktop.linux.hypr = {
    enable = lib.mkEnableOption "enable sway desktop";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = let
      startup = pkgs.pkgs.writeShellScriptBin "start" ''
        notify-send "Hello from autostart!"
      '';
      # map from name to number
      workspaces = {
        "1" = "a";
        "2" = "s";
        "3" = "d";
        "4" = "f";
        "5" = "u";
        "6" = "i";
        "7" = "o";
        "8" = "p";
      };

      # Generate keybindings from workspaces
      moves = builtins.concatLists (
        builtins.attrValues (
          builtins.mapAttrs (
            ws: key: [
              "$mod, ${key}, workspace, ${ws}"
              "$mod SHIFT, ${key}, movetoworkspace, ${ws}"
            ]
          )
          workspaces
        )
      );
    in {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        exec-once = "${startup}/bin/start";
        misc.disable_hyprland_logo = true;
        input.touchpad.natural_scroll = true;
        animation = "global, 1, 2, default";
        bind =
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
            "$mod, Return, exec, ${config.programs.foot.package}/bin/footclient"
          ]
          ++ moves;
        windowrulev2 = [
          "suppressevent maximize, class:.*"

          # tags
          "tag +term, class:footclient"
          "tag +browser, class:qutebrowser"
          "tag +preview, class:zathura, workspace:3"

          # rules
          "workspace 1, tag:term"
          "workspace 2, tag:browser"
          "workspace 3, tag:math"
          "noinitialfocus, tag:preview"
        ];
      };
    };
  };
}
