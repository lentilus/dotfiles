{
  config,
  pkgs,
  lib,
  outputs,
  ...
}: let
  cfg = config.custom.audio;
in {
  options.custom.audio = {
    enable = lib.mkEnableOption "enable pipewire and other audio related stuff";
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };

    hardware.pulseaudio.enable = lib.mkForce false;
  };
}
