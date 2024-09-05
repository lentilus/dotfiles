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
    # only to exposed the config
    # responsible for reading settings from email.acconts
    programs.mbsync = {
      enable = true;
    };

    # systemd service
    services.mbsync = {
        enable = true;
        postExec = ''
        ${pkgs.notmuch}/bin/notmuch new
        '';
    };

    home.packages = [
        pkgs.urlscan
    ];


    programs.neomutt = {
      enable = true;
      # vimKeys = true;
      sidebar = {
        enable = true;
      };
      extraConfig = builtins.readFile ./neomuttrc;

      binds = [
        # {
        #   map = [ "attach" ];
        #   key = "<return>";
        #   action = "view-mailcap";
        # }
      ];
    };

    home.file.".mailcap".text = ''
        text/html; lynx -assume_charset=%{charset} -display_charset=utf-8 -dump -width=1024 %s; nametemplate=%s.html; copiousoutput;
        text/plain; cat %s; copiousoutput
    '';

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

    accounts.email.accounts.mailbox = {
      address = "linus.preusser@mailbox.org";
      realName = "lentilus";

      userName = "linus.preusser@mailbox.org";
      imap.host = "imap.mailbox.org";
      smtp.host = "smtp.mailbox.org";

      maildir.path = "mailbox";
      passwordCommand = "PASSWORD_STORE_DIR=~/git/password-store; pass show communication/mailbox";
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
      neomutt = {
        enable = true;
      };
      notmuch = {
        enable = true;
        neomutt = {
            enable = true;
            virtualMailboxes = [
                {
                    name = "unread";
                    query = "tag:unread";
                }
                {
                    name = "shopping";
                    query = "tag:shopping";
                }
                {
                    name = "lentilus";
                    query = "tag:lentilus";
                }
                {
                    name = "linus";
                    query = "tag:linus";
                }
            ];
        };
      };
    };
  };
}
