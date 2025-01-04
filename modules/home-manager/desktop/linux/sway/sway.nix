{
  config,
  pkgs,
  lib,
  sources,
  ...
}: {
  config = lib.mkIf config.sway.enable {
    wayland.windowManager.sway = let
      mod = "Mod4";
      debouncedLauncher = pkgs.stdenv.mkDerivation {
        name = "debounced_launch";
        dontUnpack = true;
        installPhase = "install -Dm755 ${./utils/debounced_launch} $out/bin/debounced_launch";
      };
      start = "${debouncedLauncher}/bin/debounced_launch";

      focus = workspace: bin: criteria: ''
        exec ${pkgs.swayr}/bin/swayr next-matching-window \
        '[&& ${criteria} workspace="${workspace}"]' \
        || swaymsg "workspace ${workspace}; exec ${start} '${criteria}' ${bin}"'';

      # utils
      launcher = "${pkgs.rofi-wayland}/bin/rofi -show drun -G";
      nm = "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu -i";
      exit = "swaynag -t warning -m 'Exit sway?' -B 'yes' 'swaymsg exit'";
      # chnageXK = "${pkgs.xk}/bin/xk script changekasten";
      screenshot = ''        ${pkgs.grim}/bin/grim -g\
                    "$(${pkgs.slurp}/bin/slurp)" - \
                    | ${pkgs.wl-clipboard}/bin/wl-copy'';

      # desktop apps
      terminal = "${pkgs.foot}/bin/footclient";
      tmuxTerminal = '''${terminal} ${pkgs.zsh}/bin/zsh -c "tmux a"' '';
      # xk = '''${terminal} --title=xk zsh -c "${pkgs.neovim}/bin/nvim"' '';
      mail = '''${terminal} --title=aerc zsh -c "${pkgs.aerc}/bin/aerc"' '';
      files = '''${terminal} --title=files "${pkgs.ranger}/bin/ranger"' '';
      music = "${pkgs.mpv}/bin/mpv $(find $HOME/music -maxdepth 1 -mindepth 1 | ${pkgs.rofi-wayland}/bin/rofi -dmenu)";
      downloads = "${config.home.homeDirectory}/.local/scripts/dlpdf";

      # workspace bindings
      wsA = focus "1" tmuxTerminal ''app_id="footclient"'';
      wsS = focus "2" "${pkgs.qutebrowser}/bin/qutebrowser" ''app_id="qutebrowser"'';
      # wsD = focus "3" xk ''title="xk"'';
      wsF = focus "4" files ''title="files"'';
      wsU = focus "5" mail ''title="aerc"'';
    in {
      enable = true;
      extraConfig = ''
        # added here, for lowest priority, as we use foot for other apps like ranger as well.
        assign [app_id="foot"] workspace number 1
        for_window [class="Firefox"] focus none
      '';
      config = {
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
            # xkb_options = "caps:swapescape";
          };
        };
        assigns = {
          # "1" = [{app_id = "footclient";}]; # managed via extraConfig
          "2" = [{title = "qutebrowser";}];
          "3" = [{title = "xk";}];
          "4" = [{title = "files";}];
          "5" = [{title = "aerc";} {title = "Signal";}];
          "6" = [{title = "Anki";}];
          "7" = [{title = "mpv$";}];
          # "8" = []
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

          "${mod}+a" = wsA;
          "${mod}+s" = wsS;
          "${mod}+d" = "workspace number 3";
          "${mod}+f" = wsF;
          "${mod}+u" = wsU;
          "${mod}+i" = "workspace number 6";
          "${mod}+o" = "workspace number 7";
          "${mod}+p" = "workspace number 8";

          ### apps ###
          "${mod}+Space" = "exec ${launcher}";
          "${mod}+Shift+t" = "exec ${screenshot}";
          "${mod}+Shift+q" = "exec ${exit} exit";
          "${mod}+n" = "exec ${nm}";
          "${mod}+g" = "exec ${downloads}";
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+z" = "exec ${music}";
          # "${mod}+b" = "exec ${chnageXK}";
        };
      };
    };
  };
}
