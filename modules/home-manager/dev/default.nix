{
  config,
  pkgs,
  outputs,
  lib,
  ...
}: {
  options = {
    dev.enable = lib.mkEnableOption "foo";
  };

  config = lib.mkIf config.dev.enable {
    home.packages = [
      pkgs.devpod
      pkgs.htop
      pkgs.poetry
      pkgs.pyenv
      pkgs.fzf
      pkgs.git
      pkgs.lean4
      pkgs.kubectl
      pkgs.aider-chat
      # pkgs.haskellPackages.ghcup
      (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];

    home.file = {
      "${config.xdg.configHome}/git".source = "${outputs.sources.dotfiles}/git";
    };
  };
}
