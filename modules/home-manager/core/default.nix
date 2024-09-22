{
  config,
  lib,
  pkgs,
  outputs,
  ...
}: {
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./nvim.nix
  ];

  zsh.enable = lib.mkDefault true;
  tmux.enable = lib.mkDefault true;
  nvim.enable = lib.mkDefault true;

  home.file = {
    "${config.home.homeDirectory}/.local/scripts".source = outputs.sources.scripts;
  };

  home.stateVersion = "24.05"; # dont just change
}
