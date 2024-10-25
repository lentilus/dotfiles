{
  config,
  pkgs,
  lib,
  sources,
  ...
}: {
  config = lib.mkIf config.sway.enable {
    wayland.windowManager.sway = {
      enable = true;
      extraConfig = ''
        # added here, for lowest priority, as we use foot for other apps like ranger as well.
        assign [app_id="foot"] workspace number 1
      '';
      config = let
        #super key
        mod = "Mod4";

        # utils
        launcher = "${pkgs.rofi-wayland}/bin/rofi -show drun -G";
        nm = "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu -i";
        screenshot = "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";
        exit = "swaynag -t warning -m 'Exit sway?' -B 'yes' 'swaymsg exit'";

        # desktop apps
        terminal = "${pkgs.foot}/bin/footclient";
        xk_command = ''':lua require(\"telescope\") require(\"xettelkasten.zettel\").find()' '';
        xk = "${terminal} --title=xk zsh -c \"${pkgs.neovim}/bin/nvim -c ${xk_command}\"";
        mail = "${terminal} --title=mail zsh -c ${pkgs.aerc}/bin/aerc";
        files = "${terminal} --title=files ${pkgs.ranger}/bin/ranger";
        music = "${pkgs.mpv}/bin/mpv $(find $HOME/music -maxdepth 1 -mindepth 1 | ${pkgs.rofi-wayland}/bin/rofi -dmenu)";

        focus = bin: ca: ws: ''exec ${pkgs.swayr}/bin/swayr next-matching-window '[&& ${ca} workspace="${ws}"]' || swaymsg "workspace ${ws}; exec ${bin}" '';
        focus_terminal = focus "${pkgs.foot}/bin/footclient" ''app_id="footclient"'';
        focus_browser = focus "${pkgs.qutebrowser}/bin/qutebrowser" ''app_id="qutebrowser"'';
        focus_xk = focus xk ''title="xk"'';
        focus_mail = focus mail ''title="mail"'';
        focus_files = focus files ''title="files"'';
      in {
        inherit terminal;
        bars = [];
        modifier = "${mod}";
        gaps.smartBorders = "on";
        focus.newWindow = "urgent"; # focus is broken...
        workspaceAutoBackAndForth = true;
        # we run a script to focus windows on urgent
        colors = let
          colors = config.stylix.base16Scheme;
          black = "#${colors.base00}";
          white = "#${colors.base05}";
        in {
          focused = {
            border = lib.mkForce white;
            childBorder = lib.mkForce white;
          };
          unfocused = {
            border = lib.mkForce black;
            childBorder = lib.mkForce black;
          };
        };
        window = {
          border = 2;
          titlebar = false;
        };

        seat = {
          "*" = {
            hide_cursor = "when-typing enable";
          };
        };
        input = {
          # for possible inputs check swaymsg -t get_inputs
          "type:touchpad" = {
            dwt = "enabled";
            tap = "enabled";
            natural_scroll = "enabled";
            middle_emulation = "disabled";
          };
          "*" = {
            repeat_delay = "300";
            repeat_rate = "30";
            xkb_layout = "us";
            xkb_options = "caps:swapescape";
          };
        };
        assigns = {
          "2" = [{title = "qutebrowser";}];
          "3" = [{title = "xk";}];
          "4" = [
            {title = "Signal";}
            {title = "mail";}
          ];
          "5" = [
            {title = "Anki";}
            {title = "files";}
            {app_id = "com.github.xournalpp.xournalpp";}
          ];
          "7" = [{title = "mpv$";}];
          # keep at bottom for lowest prio ! not working
          # "1" = [{app_id = "foot";}];
        };
        keybindings = lib.mkForce {
          ### sway stuff ###
          "${mod}+q" = "kill";
          "${mod}+Tab" = "fullscreen";
          "${mod}+r" = "reload";

          # system controls
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86MonBrightnessUp" = "exec light -A 5";
          "XF86MonBrightnessDown" = "exec light -U 5";

          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";

          "${mod}+Shift+a" = "move container to workspace number 1";
          "${mod}+Shift+s" = "move container to workspace number 2";
          "${mod}+Shift+d" = "move container to workspace number 3";
          "${mod}+Shift+f" = "move container to workspace number 4";
          "${mod}+Shift+u" = "move container to workspace number 5";
          "${mod}+Shift+i" = "move container to workspace number 6";
          "${mod}+Shift+o" = "move container to workspace number 7";
          "${mod}+Shift+p" = "move container to workspace number 8";

          "${mod}+a" = focus_terminal "1";
          "${mod}+s" = focus_browser "2";
          # "${mod}+a" = "workspace number 1";
          # "${mod}+s" = "workspace number 2";

          # "${mod}+d" = focus_xk {ws = 3;};
          "${mod}+d" = "workspace number 3";
          # "${mod}+f" = focus_mail "4";
          "${mod}+f" = "workspace number 4";
          "${mod}+u" = focus_files "5";
          "${mod}+i" = "workspace number 6";
          "${mod}+o" = "workspace number 7";
          "${mod}+p" = "workspace number 8";

          ### apps ###
          "${mod}+Space" = "exec ${launcher}";
          "${mod}+Shift+t" = "exec ${screenshot}";
          "${mod}+Shift+q" = "exec ${exit} exit";
          "${mod}+n" = "exec ${nm}";
          "${mod}+g" = "exec ${config.home.homeDirectory}/.local/scripts/dlpdf";

          # "${mod}+Return" = "workspace 1; exec ${terminal}";
          "${mod}+Return" = "exec ${terminal}";
          # "${mod}+w" = "workspace 2; exec ${browser}";
          "${mod}+x" = "workspace 3; exec ${xk}";
          # "${mod}+m" = "workspace 4; exec ${mail}";
          # "${mod}+e" = "workspace 5; exec ${files}";
          # "${mod}+z" = "workspace 7; exec ${music}";
          "${mod}+z" = "exec ${music}";
        };
      };
    };
  };
}
