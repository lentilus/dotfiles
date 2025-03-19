{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.passwordstore;
in {
  options.passwordstore = {
    enable = lib.mkEnableOption "enable gnu password store setup";
    storePath = lib.mkOption {
      type = lib.types.str;
      description = "Path to the password store";
    };
  };

  config = let
      pass = pkgs.pass.withExtensions (_: [pkgs.pass-gocrypt]);
    in
    lib.mkIf cfg.enable {
    home.packages = [
      pkgs.wtype
      pkgs.wl-clipboard
    ];

    programs = {
      password-store = {
        enable = true;
        package = pass;
        settings.PASSWORD_STORE_DIR = cfg.storePath;
      };
      rofi.pass = {
        enable = true;
        package = pkgs.rofi-pass-wayland;
        stores = [cfg.storePath];
        extraConfig = ''
          default_autotype='path :tab pass'
          default_user=':filename'
        '';
      };
    };

    systemd.user.sessionVariables = {
      PASSWORD_STORE_DIR = cfg.storePath;
    };

    home.shellAliases = {
      pass = "pass gocrypt";
    };

    # mount encrypted store on login
    wayland.windowManager.sway.config.startup = [
      {command = "${pass}/bin/pass gocrypt open";}
    ];
  };
}
