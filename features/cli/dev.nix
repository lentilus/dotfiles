{
  config,
  pkgs,
  lib,
  ...
}: {
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
      pkgs.unstable.typst
      pkgs.unstable.go
    ];

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
}
