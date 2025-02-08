{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = let
    start = "uwsm finalize";
    stop = "uwsm stop";
    screenshot = "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";

    launcher = "${config.programs.rofi.package}/bin/rofi -show drun";
    selectWindow = "${config.programs.rofi.package}/bin/rofi -show window";
    selectPass = "${config.programs.rofi.pass.package}/bin/rofi-pass";
    viewPdf = "${pkgs.dlpdf}/bin/dlpdf";

    brightnessUp = "${pkgs.brightnessctl}/bin/brightnessctl set 10%-";
    brightnessDown = "${pkgs.brightnessctl}/bin/brightnessctl set +10%";
    volumeUp = "${pkgs.pamixer}/bin/pamixer -d 5";
    volumeDown = "${pkgs.pamixer}/bin/pamixer -i 5";
    volumeMute = "${pkgs.pamixer}/bin/pamixer -t";

    programming = "${pkgs.foot}/bin/footclient tmux";
    scratchpad = "footclient";
    browser = "${pkgs.qutebrowser}/bin/qutebrowser";
    notes = "${pkgs.foot}/bin/footclient --title=zettelkasten zsh -c \"cd ~/git/zettelkasten; zsh\"";

    # map from name to number
    workspaceKeys = ["a" "s" "d" "f" "u" "i" "o" "p"];

    moves = builtins.concatLists (
      map (i: let
        key = builtins.elemAt workspaceKeys (i - 1);
        index = toString i;
      in [
        "$mod, ${key}, workspace, ${index}"
        "$mod SHIFT, ${key}, movetoworkspace, ${index}"
      ])
      (builtins.genList (i: i + 1) (builtins.length workspaceKeys))
    );
  in {
    enable = true;

    # for uwsm compatibility
    systemd.enable = false;

    settings = {
      "$mod" = "SUPER";
      exec-once = start;
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
          "$mod Shift, Q, exec, ${stop}"
          "$mod, Tab, fullscreen"
          "$mod, Return, togglespecialworkspace"

          # move focus
          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"
          "$mod Shift, H, movewindow, l"
          "$mod Shift, J, movewindow, d"
          "$mod Shift, K, movewindow, u"
          "$mod Shift, L, movewindow, r"

          # utils
          "$mod, Space, exec, ${launcher}"
          "$mod, w, exec, ${selectWindow}"
          "$mod, x, exec, ${selectPass}"
          "$mod, t, exec, ${screenshot}"
          "$mod, r, exec, ${viewPdf}"

          # system
          ",XF86MonBrightnessDown, exec, ${brightnessUp}"
          ",XF86MonBrightnessUp, exec, ${brightnessDown}"
          ",XF86AudioLowerVolume, exec, ${volumeUp}"
          ",XF86AudioRaiseVolume, exec, ${volumeDown}"
          ",XF86AudioMute, exec, ${volumeMute}"
        ]
        ++ moves;
      windowrulev2 = [
        "suppressevent maximize, class:.*"

        "tag +communication, title:aerc"
        "tag +communication, title:Signal"
        "tag +document, class:zathura"
        "tag -document, class:zathura, workspace:3"
        "tag +media, class:mpv"

        "tag +transparent, class:footlient"
        "tag -transparent, title:tmux"

        # rules
        "workspace 4, tag:document"
        "workspace 5, tag:communication"
        "workspace 6, tag:media"

        "noinitialfocus, tag:preview"

        "workspace special, tag:special"
        "opacity 0.5 override, tag:transparent"
      ];

      workspace = [
        "special:special, on-created-empty:[float] ${scratchpad}"
        "1, on-created-empty:${programming}"
        "2, on-created-empty:${browser}"
        "3, on-created-empty:${notes}"
      ];
    };
  };

  # force electron / chromium apps to use wayland
  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
