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
    enable = lib.mkEnableOption "enable hyprland desktop";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = let
      startup = pkgs.pkgs.writeShellScriptBin "start" ''
        uwsm finalize
      '';
      screenshot = "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";

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

      # for uwsm compatibility
      systemd.enable = false;

      settings = {
        "$mod" = "SUPER";
        exec-once = "${startup}/bin/start";
        misc.disable_hyprland_logo = true;
        input.touchpad.natural_scroll = true;

        # https://wiki.hyprland.org/Configuring/Performance
        animation = "global, 0, 0, default";
        decoration = {
          blur.enabled = false;
          shadow.enabled = false;
        };
        misc.vfr = true;

        general = {
          gaps_in = 0;
          gaps_out = 0;
        };
        bind =
          [
            # controls
            "$mod, q, killactive"
            "$mod Shift, Q, exec, uwsm stop"
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

            "$mod, Return, togglespecialworkspace"

            # utils
            "$mod, Space, exec, ${config.programs.rofi.package}/bin/rofi -show drun"
            "$mod, x, exec, ${config.programs.rofi.pass.package}/bin/rofi-pass"
            "$mod, t, exec, ${screenshot}"
            "$mod, r, exec, dlpdf"

            # apps
            "$mod Shift, Return, exec, ${config.programs.foot.package}/bin/footclient --title=tmux tmux"
            "$mod, E, exec, ${config.programs.foot.package}/bin/footclient --title=zettelkasten zsh -c \"cd ~/git/zettelkasten; zsh\""
            # brightness controls
            ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%-"
            ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +10%"

            # volume controls
            ",XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5"
            ",XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
            ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
          ]
          ++ moves;
        windowrulev2 = [
          "suppressevent maximize, class:.*"

          # tags
          "tag +term, title:tmux"
          "tag +browser, class:qutebrowser"
          "tag +math, title:zettelkasten"
          "tag +preview, class:zathura, workspace:3"
          "tag +communication, title:aerc"
          "tag +communication, title:Signal"
          "tag +document, class:zathura"
          "tag -document, class:zathura, workspace:3"
          "tag +media, class:mpv"

          "tag +transparent, class:footlient"
          "tag -transparent, title:tmux"

          # rules
          "workspace 1, tag:term"
          "workspace 2, tag:browser"
          "workspace 3, tag:math"
          "workspace 4, tag:document"
          "workspace 5, tag:communication"
          "workspace 6, tag:media"

          "noinitialfocus, tag:preview"

          "workspace special, tag:special"
          "opacity 0.5 override, tag:transparent"
        ];

        workspace = [
          "special:special, on-created-empty:[float] footclient"
        ];
      };
    };
  };
}
