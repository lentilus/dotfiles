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

  config = lib.mkIf cfg.enable {
    programs.password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = cfg.storePath;
      };
    };

    home.packages = [
      pkgs.wtype
      pkgs.wl-clipboard
    ];

    programs.rofi.pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
      stores = [cfg.storePath];
      extraConfig = "";
    };
  };
}
