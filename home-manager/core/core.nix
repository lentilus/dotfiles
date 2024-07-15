{
  config,
  pkgs,
  sources,
  ...
}: {
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./nvim.nix
    ./ranger.nix
  ];

  home.file = {
    "${config.home.homeDirectory}/.local/scripts".source = sources.scripts;
  };
}
