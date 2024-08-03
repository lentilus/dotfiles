{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    zsh.enable = lib.mkEnableOption "foo";
  };

  config = lib.mkIf config.zsh.enable {
    home.packages = [
      # absoulte basic gnu core utils
      pkgs.coreutils

      pkgs.locale
      pkgs.glibcLocales
      pkgs.git
      pkgs.zsh
      pkgs.fzf
      pkgs.zoxide
    ];

    home.file = {
      "${config.xdg.configHome}/zsh".source = ../../config/zsh;
      ".zshenv".text = ''
        # move zsh config out of home
        ZDOTDIR="${config.xdg.configHome}/zsh"

        # normally added by nix installer
        if [ -e ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh ]; then
            . ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh;
        fi
      '';
    };
  };
}
