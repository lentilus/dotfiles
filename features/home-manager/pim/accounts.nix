{ config, lib, ... }:
let
  # Helper to generate a password command from a given secret key.
  secret = key: "cat ${config.sops.secrets.${key}.path}";
in {
  sops.secrets = {
    "primary-mail" = {};
    "uni-mail" = {};
    "contacts" = {};
  };

  accounts = {
    email.accounts = {
      mailbox = {
        primary = true;
        maildir.path = "mailbox";
        realName = "lentilus";
        aliases = ["*@lentilus.me"];
        address = "mail@lentilus.me";
        userName = "mail@lentilus.me";
        imap.host = "imap.mailbox.org";
        smtp.host = "smtp.mailbox.org";
        passwordCommand = secret "primary-mail";
        aerc.enable = true;
        mbsync.enable = true;
      };

      uni = {
        maildir.path = "uni";
        realName = "Linus Preusser";
        address = "linus.preusser@stud.uni-goettingen.de";
        userName = ''"ug-student\\linus.preusser"'';
        imap.host = "email.stud.uni-goettingen.de";
        # smtp.host = "email.stud.uni-goettingen.de";
        passwordCommand = secret "uni-mail";
        aerc.enable = true;
        mbsync = {
          enable = true;
          extraConfig.account.AuthMechs = "LOGIN";
        };
      };
    };

    contact.accounts.personal = {
      local = {
        type = "filesystem";
        fileExt = ".vcf";
      };
      remote = {
        type = "carddav";
        url = "https://dav.mailbox.org/carddav/32";
        userName = "mail@lentilus.me";
        passwordCommand = ["cat" config.sops.secrets."contacts".path];
      };
      vdirsyncer = {
        enable = true;
        auth = "basic";
        collections = null;
      };
      khard.enable = true;
    };
  };
}
