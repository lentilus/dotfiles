{pkgs, ...}: {
  services.mbsync.enable = true;
  programs.mbsync = {
    enable = true;
    extraConfig = ''
      # global settings
      Create Both
      Expunge Both
    '';
  };

  programs.aerc = {
    enable = true;
    package = pkgs.aerc;
    extraConfig = {
      general = {
        # we don't store any credentials, so this is fine!
        unsafe-accounts-conf = true;
        pgp-provider = "gpg";
      };

      compose.save-drafts = false;

      filters = {
        "text/plain" = "colorize";
        "text/calendar" = "calendar";
        "message/delivery-status" = "colorize";
        "message/rfc822" = "colorize";
        "text/html" = "${pkgs.html2text}/bin/html2text";
      };
    };
    extraAccounts = ''
      copy-to = Sent
      folders-sort = Inbox,Drafts,Sent,Junk,Archive,Trash
      pgp-auto-sign = true
      address-book-cmd = "khard email --parsable --remove-first-line %s"
      check-mail-cmd = "mbsync -a"
    '';
  };
}
