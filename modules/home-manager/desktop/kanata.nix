{
  config,
  pkgs,
  lib,
  outputs,
  ...
}: {
  options = {
    homeRowMods.enable = lib.mkEnableOption "enable homeRowMods via kanata";
  };

  config = lib.mkIf config.homeRowMods.enable {
    systemd.user.services.kanata = {
      Unit.Description = "kanata";
      Service.ExecStart = "${pkgs.kanata}/bin/kanata --cfg ${config.xdg.configHome}/kanata/config.kbd";
    };

    home.file = {
      "${config.xdg.configHome}/kanata".source = "${outputs.sources.dotfiles}/kanata";
    };
  };
}
