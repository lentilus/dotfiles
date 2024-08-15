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
      # ".profile".text = ''
      #   # start ssh-agent
      #   eval $(ssh-agent -s)
      #   trap 'kill $SSH_AGENT_PID' EXIT
      # '';
      ".zshenv".text = let
        configHome = config.xdg.configHome;
        home = config.home.homeDirectory;
      in ''
        # move zsh config out of home
        ZDOTDIR="${configHome}/zsh"

        # normally added by nix installer
        if [ -e ${home}/.nix-profile/etc/profile.d/nix.sh ]; then
            . ${home}/.nix-profile/etc/profile.d/nix.sh;
        fi
      '';
    };
  };
}
