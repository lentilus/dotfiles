{
  config,
  pkgs,
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
    "${config.xdg.configHome}/nvim".source = ../../config/nvim;
  };
}
