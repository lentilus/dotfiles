{pkgs, ...}: {
  position = "bottom";
  spacing = 4;
  modules-left = ["sway/workspaces" "hypr/workspaces" "idle_inhibitor" "custom/mail"];
  modules-center = [];
  modules-right = ["network" "battery" "pulseaudio" "cpu" "memory" "clock" "tray"];
  "custom/mail" = {
    exec = "${pkgs.notmuch}/bin/notmuch count tag:unread";
    interval = 60;
    format = "MAIL {}";
    tooltip = true;
  };
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
    format-wifi = "{signalStrength}: {essid}";
    format-ethernet = "eth: {cidr} ";
    format-disconnected = "offline ";
  };

  "pulseaudio" = {
    format-muted = "muted ";
    format = "VOL {volume} ";
  };

  "battery" = {
    format = "BAT {capacity}% ";
    format-charging = "charging {capacity}% ";
    states = {
      warning = 30;
      critical = 15;
    };
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
}
