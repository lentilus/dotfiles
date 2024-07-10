{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.poetry
    pkgs.pyenv
    pkgs.fzf
    pkgs.git
    pkgs.lean4
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];
}
