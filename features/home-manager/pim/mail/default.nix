{
  lib,
  config,
  pkgs,
  ...
}: {
  accounts.email.accounts = import ./accounts.nix;

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  services.mbsync.enable = true;

  programs.aerc = {
    enable = true;
    extraConfig = {
      general = {
        # we don't store any credentials, so this is fine!
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
    extraAccounts = ''
      copy-to = Sent
      folders-sort = Inbox,Drafts,Sent,Junk,Archive,Trash
    '';
  };
}
