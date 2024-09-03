{
  config,
  pkgs,
  lib,
  sources,
  ...
}: {
  config = lib.mkIf config.sway.enable {
    home.packages = [
        pkgs.i3status
    ];
    home.file."${config.xdg.configHome}/i3status/config".text = ''
        general {
                colors = true
                interval = 5
        }

        order += "wireless _first_"
        order += "ethernet _first_"
        order += "battery all"
        order += "disk /"
        order += "load"
        order += "memory"
        order += "tztime local"

        wireless _first_ {
                format_up = "W: %essid [%quality]"
                format_down = ""
        }

        ethernet _first_ {
                format_up = "E: %speed"
                format_down = ""
        }

        battery all {
                format = "%status %percentage %remaining"
                last_full_capacity = true
        }

        disk "/" {
                format = "/ %avail"
        }

        load {
                format = "%1min"
        }

        memory {
                format = "RAM %used"
                threshold_degraded = "1G"
                format_degraded = "MEMORY < %available"
        }

        tztime local {
                format = "%H:%M %d.%m.%Y "
        }
    '';
    wayland.windowManager.sway.config.bars = [
        {
            mode = "dock";
            position = "bottom";
            statusCommand = "${pkgs.i3status}/bin/i3status";
        }        
    ];
  };
}
