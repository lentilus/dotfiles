{
  config,
  pkgs,
  dotfiles,
  ...
}: {
  home.packages = [
    # tpm dependencies
    pkgs.gawk
    pkgs.gnused
    pkgs.git

    pkgs.tmux
  ];

  home.file = {
    "${config.xdg.configHome}/tmux".source = "${dotfiles}/tmux";
  };
}
