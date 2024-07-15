{
  config,
  pkgs,
  sources,
  ...
}: {
  home.packages = [
    pkgs.htop
    pkgs.poetry
    pkgs.pyenv
    pkgs.fzf
    pkgs.git
    pkgs.lean4
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

  home.file = {
    "${config.xdg.configHome}/git".source = "${sources.dotfiles}/git";
    };
}
