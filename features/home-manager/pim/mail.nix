{config, pkgs, ...}: {
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

  # I think we can get rid of the below, since I only want this to be able to
  # trigger syncing from aerc. But we can also achieve this by just nudging
  # the service.
  programs.mbsync = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "mbsync";
      paths = [ pkgs.isync ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/mbsync \
          --add-flags "--config=${config.sops.secrets."mbsyncrc".path}"
      '';
    };
  };

  programs.aerc = {
    enable = true;

    # manage accounts-conf with sops-nix
    package = pkgs.symlinkJoin {
      name = "aerc-custom";
      paths = [ pkgs.aerc ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/aerc \
          --add-flags "--accounts-conf=${config.sops.secrets."aerc-accounts-conf".path}"
      '';
    };

    extraConfig = {
      general.pgp-provider = "gpg";
      compose.save-drafts = false;

      filters = {
        "text/plain" = "colorize";
        "text/calendar" = "calendar";
        "message/delivery-status" = "colorize";
        "message/rfc822" = "colorize";
        "text/html" = "${pkgs.html2text}/bin/html2text";
      };
    };
  };
}
