{
  config,
  lib,
  ...
}: let
  cfg = config.services.homeRowMods;
in {
  options.services.homeRowMods = {
    enable = lib.mkEnableOption "enable home-row-mods using kanata";
  };

  config = lib.mkIf cfg.enable {
    services.kanata = {
      enable = true;
      keyboards = {
        all = {
          devices = []; # empty list applies to all keyboards
          extraDefCfg = "process-unmapped-keys yes";
          config = ''
            (defsrc
              caps a s d f j k l ;
            )
            (defvar
              tap-time 180
              hold-time 190
            )

            (defalias
              capsesc esc
              a (tap-hold-release $tap-time $hold-time a lsft)
              s (tap-hold-release $tap-time $hold-time s lmet)
              d (tap-hold-release $tap-time $hold-time d lalt)
              f (tap-hold-release $tap-time $hold-time f lctl)
              j (tap-hold-release $tap-time $hold-time j rctl)
              k (tap-hold-release $tap-time $hold-time k ralt)
              l (tap-hold-release $tap-time $hold-time l rmet)
              ; (tap-hold-release $tap-time $hold-time ; rsft)
            )

            (deflayer base
              @capsesc @a @s @d @f @j @k @l @;
            )
          '';
        };
      };
    };
  };
}
