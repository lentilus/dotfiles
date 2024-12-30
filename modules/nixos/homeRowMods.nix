{
  config,
  pkgs,
  lib,
  outputs,
  ...
}: {
  options = {
    homeRowMods.enable = lib.mkEnableOption "enable home-row-mods using kanata";
  };

  config = lib.mkIf config.homeRowMods.enable {
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
              tap-time 170
              hold-time 200
            )

            (defalias
              capsesc esc
              a (tap-hold $tap-time $hold-time a lsft)
              s (tap-hold $tap-time $hold-time s lmet)
              d (tap-hold $tap-time $hold-time d lalt)
              f (tap-hold $tap-time $hold-time f lctl)
              j (tap-hold $tap-time $hold-time j rctl)
              k (tap-hold $tap-time $hold-time k ralt)
              l (tap-hold $tap-time $hold-time l rmet)
              ; (tap-hold $tap-time $hold-time ; rsft)
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
