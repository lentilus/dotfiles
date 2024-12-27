{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.sway.enable {
    home.packages = [
      pkgs.dunst
      pkgs.networkmanager_dmenu
    ];

    wayland.windowManager.sway.systemd = {
      enable = true;
      extraCommands = [
        "systemctl --user reset-failed"
        "systemctl --user start sway-session.target"

        # wait for sway to stop
        "swaymsg -mt subscribe '[]' || true"
        "systemctl --user stop sway-session.target"

        # unsure if necessary. Needs more investigation
        "systemctl --user stop graphical-session.target"
      ];
    };

    programs.swayr = {
      enable = true;
      systemd.enable = true;
      systemd.target = "sway-session.target";
    };

    programs.foot = {
      settings.main.term = "xterm-256color";
      enable = true;
      server.enable = true; # we start it from sway
    };

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };

    systemd.user.services.autotiling = {
      Unit = {
        Description = "sway autotiling";
        PartOf = ["sway-session.target"];
        After = ["sway-session.target"];
      };
      Install = {
        WantedBy = ["sway-session.target"];
      };

      Service = {
        ExecStart = "${pkgs.autotiling-rs}/bin/autotiling-rs -w 1 3 4 5 6 7 8";
      };
    };

    # services.gnome-keyring.enable = true;
    # services.gpg-agent = {
    #   enable = true; # we start it from sway
    #   # enableExtraSocket = true; # for GPG-Agent forwarding?
    #   # enableSshSupport = true;
    # };
    #
    # services.ssh-agent.enable = true; # we start it from sway
  };
}
