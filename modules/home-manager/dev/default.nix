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
      pkgs.unstable.aider-chat
      # pkgs.haskellPackages.ghcup
      pkgs.unstable.nerd-fonts.jetbrains-mono
      pkgs.unstable.go
    ];

    programs.pyenv.enable = true;

    programs.git = {
      enable = true;
      userName = "lentilus";
      userEmail = "lentilus@mailbox.org";
    };
  };
}
