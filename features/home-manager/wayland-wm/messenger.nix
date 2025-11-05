{pkgs, ...}: {
  home.packages = with pkgs; [
    signal-desktop
  ];

  # autostart
  wayland.windowManager.sway.config.startup = [
    {command = "signal-desktop --start-in-tray";}
  ];
}
