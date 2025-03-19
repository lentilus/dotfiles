{
  programs.git = {
    enable = true;
    userName = "lentilus";
    userEmail = "mail@lentilus.me";
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };
}
