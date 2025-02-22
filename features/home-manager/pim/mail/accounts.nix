{
  mailbox = {
    primary = true;
    address = "linus.preusser@mailbox.org";
    realName = "Linus Preusser";

    userName = "linus.preusser@mailbox.org";
    imap.host = "imap.mailbox.org";
    smtp.host = "smtp.mailbox.org";

    maildir.path = "mailbox";
    passwordCommand = "withsc pass communication/mailbox";

    aliases = [
      "lentilus@mailbox.org"
      "linus.shopping@mailbox.org"
    ];

    aerc = {
      enable = true;
      extraAccounts.address-book-cmd = "khard email --parsable --remove-first-line %s";
    };

    msmtp.enable = true;
    mbsync = {
      enable = true;
      create = "both";
      expunge = "both";
    };

    gpg = {
      key = "0x6594ADA13130D0CD";
      signByDefault = true;
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
    passwordCommand = "withsc pass uni/ecampus";

    aerc.enable = true;
    msmtp.enable = true;
    mbsync = {
      enable = true;
      create = "both";
      expunge = "both";
      extraConfig.account.AuthMechs = "LOGIN";
    };
  };
}
