{
  config,
  pkgs,
  lib,
  outputs,
  ...
}: let
  cfg = config.custom.authentication;
in {
  options.custom.authentication = {
    enable = lib.mkEnableOption "enable graphical polikit agent (polkit-gnome) and yubikey related services";
  };

  config = lib.mkIf cfg.enable {
    security.polkit.enable = true;

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # for yubikey gpg stuff
    services = {
      pcscd.enable = true;
      udev.packages = [pkgs.yubikey-personalization];
    };
  };
}
