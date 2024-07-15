{
  config,
  pkgs,
  sources,
  ...
}: {
  home.packages = [
    # plugin dependencies
    pkgs.fd
    pkgs.ripgrep
    pkgs.cargo
    pkgs.neovim
  ];

  home.file = {
    "${config.xdg.configHome}/nvim".source = "${sources.dotfiles}/nvim";
  };
}
