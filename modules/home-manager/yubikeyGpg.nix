{
  config,
  lib,
  pkgs,
  ...
}: let
in {
  options.yubikeyGpg = {
    enable = lib.mkEnableOption "enable yubi-key based gpg identity";

    publicKeyPath = lib.mkOption {
      type = lib.types.path;
      description = "Path to the exported gpg public key";
    };

    pinentryPackage = lib.mkOption {
      type = lib.types.package;
      description = "the pinentry package";
    };
  };

  config = lib.mkIf config.yubikeyGpg.enable {
    programs.gpg = {
      enable = true;

      publicKeys = [
        {
          source = config.yubikeyGpg.publicKeyPath;
          trust = 5;
        }
      ];

      # https://support.yubico.com/hc/en-us/articles/4819584884124-Resolving-GPG-s-CCID-conflicts
      scdaemonSettings = {
        disable-ccid = true;
      };

      # https://github.com/drduh/config/blob/master/gpg.conf
      settings = {
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
        default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";
        charset = "utf-8";
        fixed-list-mode = true;
        no-comments = true;
        no-emit-version = true;
        keyid-format = "0xlong";
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        with-fingerprint = true;
        require-cross-certification = true;
        no-symkey-cache = true;
        use-agent = true;
        throw-keyids = true;

        # some additions
        with-keygrip = true;
      };
    };

    # https://github.com/nix-community/home-manager/issues/6067
    home.file."${config.programs.gpg.homedir}/common.conf".text = ''
      # use-keyboxd
    '';

    services.gpg-agent = {
      enable = true;

      # https://github.com/drduh/config/blob/master/gpg-agent.conf
      defaultCacheTtl = 600; # 1h
      maxCacheTtl = 7200; # 2h
      pinentryPackage = config.yubikeyGpg.pinentryPackage;
      extraConfig = ''
        ttyname $GPG_TTY
      '';

      # enableZshIntegration = false;
      # enableExtraSocket = true;
      enableSshSupport = true;
      # sshKeys = [ "63952DB05F2B15C30F7FD09B2ACDC80F7FB03AE1" ];
      sshKeys = [ "0C5B390F0ECDC5446622AE31F0916A3588C5B284" ];
    };

    programs.git = {
      enable = true;
      userName = "lentilus";
      userEmail = "lentilus@mailbox.org";

      # let git decide depending on author
      signing.key = null;
      extraConfig.commit.gpgsign = true;
    };
  };
}
