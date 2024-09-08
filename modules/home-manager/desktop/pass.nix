{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    pass.enable = lib.mkEnableOption "enable gnu pass";
  };

  config = lib.mkIf config.pass.enable {
    programs.password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "${config.home.homeDirectory}/git/password-store";
      };
    };
  };
}
