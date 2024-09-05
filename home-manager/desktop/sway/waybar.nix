{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.sway.enable {

    programs.waybar.systemd = {
        enable = true;
        target = "sway-session.target";
    };
    stylix.targets.waybar.enable = false;
    programs.waybar = {
      enable = true;
      settings.mainBar = {
        position = "bottom";
        spacing = 4;
        modules-left = [ "sway/workspaces" "idle_inhibitor" ];
        modules-center = [];
        modules-right = ["network" "battery" "pulseaudio" "cpu" "memory" "clock" "tray"];
        "sway/workspaces" = {
          disable-scroll = true;
          format = "{icon}";
          format-icons = {
            "1" = "a";
            "2" = "s";
            "3" = "d";
            "4" = "f";
            "5" = "u";
            "6" = "i";
            "7" = "o";
            "8" = "p";
          };
        };

        "network" = {
            format-wifi =  "W {essid} ({signalStrength}) ";
            format-ethernet =  "E {cidr} ";
            format-disconnected =  "offline ";
        };

        "pulseaudio" = {
            format-muted = "muted ";
            format = "VOL {volume} ";
        };

        "battery" = {
            format = "BAT {capacity}% ";
        };

        "cpu" = {
            format = "CPU {usage}% ";
        };

        "memory" = {
            format = "RAM {used}G ";
        };

        "clock" = {
            format = "{:%H:%M %d.%m.%y}";
        };

        "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
                activated = " O.O ";
                deactivated = " -.- ";
            };
        };

      };
      style = let
        colors = config.stylix.base16Scheme;
        font = config.stylix.fonts.monospace.name;
        black = "#${colors.base00}";
        white = "#${colors.base04}";
        red = "#${colors.base08}";
        brightWhite = "#${colors.base07}";
        yellow = "#${colors.base0A}";
        green =  "#${colors.base0B}";
      in ''
        * {
            font-family: ${font};
            font-size: 14px;
            border: none;
            margin: 0;
            border-radius: 0;
        }

        window#waybar {
            background-color: ${black};
            color: ${white};
        }

        #workspaces button {
            padding: 0 0px;
            color: ${white};
        }

        #workspaces button.focused {
            background-color: ${white};
            color: ${black};
        }

        #network.disconnected {
            color: ${red};
        }

        #network:not(.disconnected) {
            color: ${green};
        }

        #idle_inhibitor.activated {
            color: ${brightWhite};
        }

        #pulseaudio.muted {
            color: ${yellow};
        }

        '';
    };
  };
}
