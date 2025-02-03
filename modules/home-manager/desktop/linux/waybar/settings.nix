{pkgs, ...}: {
  position = "bottom";
  spacing = 4;
  modules-left = ["sway/workspaces" "hyprland/workspaces" "idle_inhibitor" "custom/mail" "custom/sys"];
  modules-center = ["hyprland/window"];
  modules-right = ["network" "battery" "pulseaudio" "cpu" "memory" "clock" "tray"];

  cpu.format = "CPU {usage}% ";
  memory.format = "RAM {used}G ";
  clock.format = "{:%H:%M %d.%m.%y}";

  "custom/mail" = {
    exec = "find ~/Maildir/**/new/ -type f | wc -l";
    interval = 30;
    format = "MAIL {}";
  };
    
  "custom/sys" = {
    exec = "${pkgs.syshealth}/bin/syshealth";
    format = "SYS {}";
  };

  network = {
    format-wifi = "{signalStrength}: {essid}";
    format-ethernet = "eth: {cidr} ";
    format-disconnected = "offline ";
  };

  pulseaudio = {
    format-muted = "muted ";
    format = "VOL {volume} ";
  };

  battery = {
    format = "BAT {capacity}% ";
    format-charging = "charging {capacity}% ";
    states = {
      warning = 30;
      critical = 15;
    };
    interval = 20;
  };

  idle_inhibitor = {
    format = "{icon}";
    format-icons = {
      activated = " O.O ";
      deactivated = " -.- ";
    };
  };
}
