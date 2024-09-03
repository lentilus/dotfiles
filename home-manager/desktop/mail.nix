{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    mail.enable = lib.mkEnableOption "enable mutt mail client";
  };

  config = lib.mkIf config.mail.enable {
    programs.mbsync = {
      enable = true;
    };

    programs.neomutt = {
      enable = true;
      vimKeys = false;
      binds = [
        {
          map = "attach";
          key = "<return>";
          action = "view-mailcap";
        }
      ];
    };

    accounts.email.accounts.mailbox = {
      address = "linus.preusser@mailbox.org";
      maildir.path = "mailbox";
      realName = "lentilus";
      primary = true;
      mbsync = {
        enable = true;
        create = "both";
      };
      neomutt = {
        enable = true;
      };
      userName = "linus.preusser@mailbox.org";
      imap.host = "imap.mailbox.org";
      smtp.host = "smtp.mailbox.org";
      passwordCommand = "PASSWORD_STORE_DIR=~/git/password-store; pass show communication/mailbox";
    };
  };

  # config = lib.mkIf config.mail.enable {
  #   home.file.mbsync_config = {
  #       target = ".nix_mbsyncrc";
  #       text = "hello world";
  #   };
  #   services.mbsync = {
  #       enable = true;
  #       configFile =  config.home.file.mbsync_config;
  #   };
  # };
}
