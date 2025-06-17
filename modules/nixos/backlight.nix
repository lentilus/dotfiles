{
  config,
  lib,
  ...
}: let
  cfg = config.services.backlight;
in {
  options.services.backlight = {
    enable = lib.mkEnableOption "enable backlight control";
  };

  config = lib.mkIf cfg.enable {
    programs.light.enable = true;
    services.actkbd = {
      enable = true;
      bindings = [
        {
          keys = [224];
          events = ["key"];
          command = "/run/current-system/sw/bin/light -U 10";
        }
        {
          keys = [225];
          events = ["key"];
          command = "/run/current-system/sw/bin/light -A 10";
        }
      ];
    };
  };
}
