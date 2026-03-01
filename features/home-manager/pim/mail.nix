{
  config,
  pkgs,
  ...
}: {
  sops.secrets = {
    "mbsyncrc" = {
      sopsFile = ../../../secrets/mbsyncrc;
      format = "binary";
    };
    "aerc-accounts-conf" = {
      sopsFile = ../../../secrets/aerc-accounts.conf;
      format = "binary";
    };
  };

  services.mbsync = {
    enable = true;
    configFile = config.sops.secrets."mbsyncrc".path;
  };

  programs.aerc = {
    enable = true;

    # manage accounts-conf with sops-nix
    package = pkgs.symlinkJoin {
      name = "aerc-custom";
      paths = [pkgs.unstable.aerc];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/aerc \
          --add-flags "--accounts-conf=${config.sops.secrets."aerc-accounts-conf".path}"
      '';
    };

    extraConfig = {
      general.pgp-provider = "gpg";
      compose.save-drafts = false;
      account-hooks.from = "recipient";

      filters = {
        "text/plain" = "colorize";
        "text/calendar" = "calendar";
        "message/delivery-status" = "colorize";
        "message/rfc822" = "colorize";
        "text/html" = "html";
      };
    };
  };
}
