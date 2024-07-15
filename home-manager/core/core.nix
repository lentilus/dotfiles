{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./nvim.nix
    ./ranger.nix
  ];

  home.file = {
    "${config.home.homeDirectory}/.local/scripts".source = ../../config/scripts;
  };
}
