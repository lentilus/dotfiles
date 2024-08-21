{
  lib,
  config,
  ...
}: {
  options = {
    kanshi.enable = lib.mkEnableOption "foo";
  };

  config = lib.mkIf config.kanshi.enable {
    services.kanshi = {
      enable = true;
      systemdTarget = "sway-session.target";
      settings = let
        laptop = "eDP-1";
        docked = "DP-2";
      in [
        {
          profile = {
            name = "standalone";
            outputs = [
              {
                criteria = laptop;
                status = "enable";
              }
            ];
          };
        }
        {
          profile = {
            name = "docked";
            outputs = [
              {
                criteria = laptop;
                status = "disable";
              }
              {
                criteria = docked;
                status = "enable";
              }
            ];
          };
        }
      ];
    };
  };
}
