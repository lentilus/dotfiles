{
  config,
  pkgs,
  lib,
  outputs,
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
      "${config.xdg.configHome}/zsh" = {
        source = "${outputs.sources.dotfiles}/zsh";
        recursive = true;
      };
      ".zshenv".source = "${outputs.sources.dotfiles}/zsh/_.zshenv";
    };
  };
}
