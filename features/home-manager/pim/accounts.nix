{
  pkgs,
  lib,
  ...
}: let
  host = "mailbox.org";
  mail = "mail@lentilus.me";
  pass = "${pkgs.pass}/bin/pass show gocrypt/pim/${host}/${mail}";
in {
  accounts = {
    email.accounts = {
      mailbox = {
        primary = true;
        address = mail;
        realName = "lentilus";
        userName = mail;
        imap.host = "imap.${host}";
        smtp.host = "smtp.${host}";
        maildir.path = "mailbox";
        passwordCommand = pass;
        aliases = ["*@lentilus.me"];
        aerc.enable = true;
        mbsync.enable = true;
      };

      uni = {
        address = "linus.preusser@stud.uni-goettingen.de";
        realName = "Linus Preusser";
        userName = ''"ug-student\\linus.preusser"'';
        imap.host = "email.stud.uni-goettingen.de";
        # smtp.host = "email.stud.uni-goettingen.de";
        maildir.path = "uni";
        passwordCommand = "${pkgs.pass}/bin/pass gocrypt/uni/ecampus.uni-goettingen.de/linus.preusser";
        aerc.enable = true;
        mbsync = {
          enable = true;
          extraConfig.account.AuthMechs = "LOGIN";
        };
      };
    };

    calendar.accounts = let
      template = id: {
        remote = {
          type = "caldav";
          url = "https://dav.${host}/caldav/${id}";
          userName = mail;
          passwordCommand = lib.strings.splitString " " pass;
        };
        vdirsyncer = {
          enable = true;
          auth = "basic";
          collections = null;
          metadata = ["color"];
        };
        khal.enable = true;
      };
    in {
      personal = template "Y2FsOi8vMC8zMQ";
      birthdays = template "Y2FsOi8vMS8w";
      todo = template "MzM" // {khal.enable = false;};
    };

    contact.accounts = {
      personal = {
        local = {
          type = "filesystem";
          fileExt = ".vcf";
        };
        remote = {
          type = "carddav";
          url = "https://dav.${host}/carddav/32";
          userName = mail;
          passwordCommand = lib.strings.splitString " " pass;
        };
        vdirsyncer = {
          enable = true;
          auth = "basic";
          collections = null;
        };
        khard.enable = true;
      };
    };
  };
}
