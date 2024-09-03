{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.sway.enable {
    programs.waybar = {
      enable = true;
      settings.mainBar = {
        spacing = 4;
        modules-left = ["sway/workspaces" "backlight" "idle_inhibitor"];
        modules-center = ["sway/window"];
        modules-right = ["pulseaudio" "cpu" "temperature" "memory" "battery#time" "battery#bat0" "tray" "clock"];
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
          persistent_workspaces = {
            "1" = "[]";
            "2" = "[]";
            "3" = "[]";
            "4" = "[]";
            "5" = "[]";
            "6" = "[]";
            "7" = "[]";
            "8" = "[]";
          };
        };
      };
      style = let
        colors = config.stylix.base16Scheme;
        font = config.stylix.fonts.monospace.name;
        black = "#${colors.base00}";
        white = "#${colors.base05}";
      in ''
        * {
            font-family: ${font};
            font-size: 14px;
            border-bottom-right-radius: 0;
            border-bottom-left-radius: 0;
            border-top-right-radius: 0;
            border-top-left-radius: 0;
            margin-left: 0;
            margin-right: 0;
            transition-duration: 0.0s;
        }

        #workspaces button {
          padding: 0 0px;
          color: ${white};
          background-color: transparent;
        }

        #workspaces button.persistent {
          background-color: transparent;
          color: transparent;
        }

        #workspaces button.focused {
          background-color: ${white};
          color: ${black};
        }
      '';
    };
  };
}
