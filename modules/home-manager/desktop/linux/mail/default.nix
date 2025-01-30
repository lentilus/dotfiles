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
    # sync with mail-server
    programs.mbsync.enable = true;
    # send email
    programs.msmtp.enable = true;

    services.mbsync = {
      enable = true;
      postExec = ''
        # ${pkgs.notmuch}/bin/notmuch new
      '';
    };

    programs.aerc = {
      enable = true;
      extraConfig = {
        # we don't store any credentials, so this is fine!
        general = {
          unsafe-accounts-conf = true;
          pgp-provider = "gpg";
        };

        filters = {
          "text/plain" = "colorize";
          "text/calendar" = "calendar";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
          "text/html" = "${pkgs.w3m}/bin/w3m -T text/html -cols $(tput cols)\
                -dump -o display_image=false -o display_link_number=true";
        };
      };
    };

    accounts.email.accounts = {
      mailbox = {
        primary = true;
        address = "linus.preusser@mailbox.org";
        realName = "Linus Preusser";

        userName = "linus.preusser@mailbox.org";
        imap.host = "imap.mailbox.org";
        smtp.host = "smtp.mailbox.org";

        maildir.path = "mailbox";
        passwordCommand = "pass show communication/mailbox";

        aliases = [
          "lentilus@mailbox.org"
          "linus.shopping@mailbox.org"
        ];

        aerc.enable = true;
        msmtp.enable = true;
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
        };
      };

      uni = {
        address = "linus.preusser@stud.uni-goettingen.de";
        realName = "Linus Preusser";
        userName = ''"ug-student\\linus.preusser"'';
        imap.host = "email.stud.uni-goettingen.de";
        smtp = {
          host = "email.stud.uni-goettingen.de";
          port = 587;
          tls.useStartTls = true;
        };

        maildir.path = "uni";
        passwordCommand = "pass show uni/ecampus";

        aerc.enable = true;
        msmtp.enable = true;
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
          extraConfig.account.AuthMechs = "LOGIN";
        };
      };
    };
  };
}
