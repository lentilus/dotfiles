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
    # we need pass enable to retrieve imap secrets
    programs.mbsync = assert config.pass.enable == config.mail.enable; {
      enable = true;
    };

    services.mbsync = {
      # systemd service
      enable = true;
      postExec = ''
        ${pkgs.notmuch}/bin/notmuch new
      '';
    };

    programs.msmtp = {
      enable = true;
    };

    programs.notmuch = {
      enable = true;
      new = {
        tags = ["inbox" "unread"];
      };
      hooks = {
        postNew = ''
          notmuch tag +shopping -- tag:inbox and to:linus.shopping@mailbox.org
          notmuch tag +lentilus -- tag:inbox and to:lentilus@mailbox.org
          notmuch tag +linus -- tag:inbox and to:linus.preusser@mailbox.org
        '';
      };
    };

    home.file.aercNmQueries = {
      target = "${config.xdg.configHome}/aerc/nm-qmap";
      text = ''
        INBOX = tag:inbox and not tag:archived
        unread = tag:unread
        lentilus = tag:lentilus
        linus = tag:linus
        shopping = tag:shopping
      '';
    };

    programs.aerc = {
      enable = true;
      # we don't store any credentials, so this is fine!
      extraConfig.general.unsafe-accounts-conf = true;
      extraAccounts.mailboxtest = {
        source = "notmuch://~/Maildir";
        from = "lentilus <lentilus@mailbox.org>";
        query-map = "~/${config.home.file.aercNmQueries.target}";
        outgoing = "${pkgs.msmtp}/bin/msmtp";
        # maildir-store = "~/Maildir";
      };
    };

    accounts.email.accounts.mailbox = {
      address = "linus.preusser@mailbox.org";
      realName = "lentilus";

      userName = "linus.preusser@mailbox.org";
      imap.host = "imap.mailbox.org";
      smtp.host = "smtp.mailbox.org";

      maildir.path = "mailbox";
      # passwordCommand = "PASSWORD_STORE_DIR=~/git/password-store; pass show communication/mailbox";
      passwordCommand = "${pkgs.pass}/bin/pass show communication/mailbox";
      primary = true;

      aliases = [
        "lentilus@mailbox.org"
        "linus.shopping@mailbox.org"
      ];

      mbsync = {
        enable = true;
        create = "both";
        extraConfig.account = {
          PipelineDepth = 20;
          timeout = 3600;
        };
      };

      notmuch.enable = true;
      msmtp.enable = true;
    };
  };
}
