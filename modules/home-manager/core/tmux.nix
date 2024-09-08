{
  config,
  pkgs,
  lib,
  outputs,
  ...
}: {
  options = {
    tmux.enable = lib.mkEnableOption "foo";
  };

  config = lib.mkIf config.tmux.enable {
    home.packages = [
      # tpm dependencies
      pkgs.gawk
      pkgs.gnused
      pkgs.git

      pkgs.tmux
    ];

    home.file = {
      "${config.xdg.configHome}/tmux".source = "${outputs.sources.dotfiles}/tmux";
    };
  };
}
