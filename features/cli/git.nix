{
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
