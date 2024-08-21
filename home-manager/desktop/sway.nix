{
  config,
  pkgs,
  lib,
  sources,
  ...
}: {
  options = {
    sway.enable = lib.mkEnableOption "foo";
  };

  config = lib.mkIf config.sway.enable {
    home.packages = [
      # desktop dependencies
      pkgs.nixgl.nixGLIntel
      pkgs.dunst
      pkgs.pipewire
    ];
    programs.swayr = {
        enable = true;
        systemd.enable = true;
        systemd.target = "sway-session.target";

    };
    programs.foot = {
      enable = true;
      server.enable = true;
    };
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };

    programs.qutebrowser = {
      enable = true;
      settings = {
        tabs.show = "never";
        scrolling.bar = "never";
        content.blocking.method = "both";
      };
      keyBindings.normal = {
       "<Space>ff" = "cmd-set-text -s :tab-select";
       "<Space>g" = ":tab-give";
       "<Ctrl+o>" = ":tab-prev";
       "<Tab>" = ":tab-next";
       };
    };

    home.file.".config/qutebrowser/blocked-hosts".text = "www.youtube.com";

    services.gnome-keyring.enable = true;
    services.gpg-agent = {
      enable = true;
      # enableExtraSocket = true; # for GPG-Agent forwarding?
      # enableSshSupport = true;
    };
    services.ssh-agent.enable = true;

    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
      config = let


        #super key
        mod = "Mod4";

        # utils
        # bar = "${pkgs.waybar}/bin/waybar";
        launcher = "${pkgs.rofi-wayland}/bin/rofi -show drun -G";
        screenshot = "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";
        exit = "swaynag -t warning -m 'Exit sway?' -B 'yes' 'swaymsg exit'";

        # desktop apps
        terminal = "${pkgs.foot}/bin/footclient";
        xk_command = '' ':lua require("telescope") require("xettelkasten.zettel").find()' '';
        # xk = "${terminal} --title=xk ${pkgs.neovim}/bin/nvim -c ${xk_command}";
        mail = "${terminal} --title=mail ${pkgs.neomutt}/bin/neomutt";
        files = "${terminal} --title=files ${pkgs.ranger}/bin/ranger";
        music = "${pkgs.mpv}/bin/mpv $(find $HOME/music -maxdepth 1 -mindepth 1 | ${pkgs.rofi-wayland}/bin/rofi -dmenu)";

        focus = {bin, criteria, workspace}:
        ''exec ${pkgs.swayr}/bin/swayr next-matching-window '[&& ${criteria} workspace="${workspace}"]' || swaymsg "workspace ${workspace}; exec ${bin}" '';
        focus_terminal = focus { bin ="${pkgs.foot}/bin/footclient"; criteria=''app_id="footclient"''; workspace="1";};
        focus_browser = focus { bin="${pkgs.qutebrowser}/bin/qutebrowser"; criteria=''app_id="qutebrowser"''; workspace="2";};
        # focus_xk = focus {bin=xk; criteria=''title="xk"''; workspace="3";};
        focus_mail = focus {bin=mail; criteria=''title="mail"''; workspace="4";};
        focus_files = focus {bin=files; criteria=''title="files"''; workspace="5";};

      in {
        inherit terminal;
        modifier = "${mod}";
        # bars = [{command = "${bar}";}];
        bars = [];

        ### styling ###
        gaps = {
          inner = 8;
          outer = 0;
          smartBorders = "on";
          smartGaps = true;
        };
        colors = let
            colors = config.stylix.base16Scheme;
            black = "#${colors.base00}";
            white = "#${colors.base05}";
        in {
            focused = {
                border = lib.mkForce white;
                childBorder = lib.mkForce white;
            };
            unfocused =  {
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
        startup = [
          {
            command = "sleep 2; systemctl --user restart kanshi.service";
            always = true;
          }
          {
            command = "${pkgs.autotiling-rs}/bin/autotiling-rs -w 1 3 4 5 6 7 8";
            always = true;
          }
        ];
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

          "${mod}+a" = focus_terminal;
          "${mod}+s" = focus_browser;
          # "${mod}+d" = focus_xk;
          "${mod}+d" = "workspace number 3";
          "${mod}+f" = focus_mail;
          "${mod}+u" = focus_files;
          "${mod}+i" = "workspace number 6";
          "${mod}+o" = "workspace number 7";
          "${mod}+p" = "workspace number 8";

          ### apps ###
          "${mod}+Space" = "exec ${launcher}";
          "${mod}+Shift+t" = "exec ${screenshot}";
          "${mod}+Shift+q" = "exec ${exit} exit";

          "${mod}+Return" = "workspace 1; exec ${terminal}";
          # "${mod}+w" = "workspace 2; exec ${browser}";
          # "${mod}+x" = "workspace 3; exec ${xk}";
          # "${mod}+m" = "workspace 4; exec ${mail}";
          # "${mod}+e" = "workspace 5; exec ${files}";
          # "${mod}+z" = "workspace 7; exec ${music}";
          "${mod}+z" = "exec ${music}";
        };
      };
    };
  };
}
