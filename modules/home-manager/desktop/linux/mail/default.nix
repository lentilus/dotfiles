{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktop.linux.mail;
in {
  options.desktop.linux.mail = {
    enable = lib.mkEnableOption "enable mutt mail client";
  };

  config = lib.mkIf cfg.enable {
    programs.mbsync = {
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
        NEW = tag:unread
        INBOX = folder:mailbox/Inbox
        SENT = folder:mailbox/Sent
        lentilus = tag:lentilus
        linus = tag:linus
        shopping = tag:shopping
      '';
    };

    home.file.aercFolderMap = {
      target = "${config.xdg.configHome}/aerc/folders.map";
      text = ''
        m = mailbox*
      '';
    };

    programs.aerc = {
      enable = true;
      # we don't store any credentials, so this is fine!
      extraConfig = {
        general.unsafe-accounts-conf = true;
        filters = {
          "text/plain" = "colorize";
          "text/calendar" = "calendar";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
          "text/html" = "w3m -T text/html -cols $(tput cols) -dump -o display_image=false -o display_link_number=true";
        };
      };

      extraAccounts.mailboxtest = {
        source = "notmuch://~/Maildir";
        outgoing = "${pkgs.msmtp}/bin/msmtp";
        from = "Linus Preusser <linus.preusser@mailbox.org>";
        default = "NEW";
        folders-sort = "NEW, INBOX, SENT";
        query-map = "${config.home.homeDirectory}/${config.home.file.aercNmQueries.target}";
        folders-exclude = "~mailbox*";
        aliases = "Linus Preusser <linus.preusser@mailbox.org>, Lentilus <lentilus@mailbox.org>, Linus <linus.shopping@mailbox.org>";
        maildir-store = "~/Maildir";
        copy-to = "mailbox/Sent";
      };
    };

    accounts.email.accounts = {
      mailbox = {
        address = "linus.preusser@mailbox.org";
        realName = "Linus Preusser";

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
          expunge = "both";
        };

        notmuch.enable = true;
        msmtp.enable = true;
      };
    };
  };
}
