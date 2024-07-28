{
  config,
  lib,
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

  zsh.enable = lib.mkDefault true;
  tmux.enable = lib.mkDefault true;
  nvim.enable = lib.mkDefault true;
  ranger.enable = lib.mkDefault true;

  home.file = {
    "${config.home.homeDirectory}/.local/scripts".source = sources.scripts;
  };
}
