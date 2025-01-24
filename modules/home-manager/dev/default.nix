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
      pkgs.pipx
      pkgs.fzf
      pkgs.git
      pkgs.lean4
      pkgs.kubectl
      pkgs.unstable.aider-chat
      pkgs.unstable.typst
      # pkgs.haskellPackages.ghcup
      pkgs.unstable.nerd-fonts.jetbrains-mono
      pkgs.unstable.go
    ];

    programs.pyenv.enable = true;

    programs.git = {
      enable = true;
      userName = "lentilus";
      userEmail = "lentilus@mailbox.org";
      lfs.enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        rebase.autoStash = true;
      };
    };
  };
}
