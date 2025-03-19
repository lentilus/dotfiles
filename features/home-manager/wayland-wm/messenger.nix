{pkgs, ...}: {
  home.packages = with pkgs; [
    zapzap
    signal-desktop
  ];

  # autostart
  wayland.windowManager.sway.config.startup = [
    {command = "signal-desktop --start-in-tray";}
    {command = "zapzap";}
  ];
}
