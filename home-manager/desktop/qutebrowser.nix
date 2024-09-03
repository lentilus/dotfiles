{
  config,
  pkgs,
  lib,
  sources,
  ...
}: {
  options = {
    browser.enable = lib.mkEnableOption "enable qutebrowser config";
  };

  config = let
    qutePass = pkgs.stdenv.mkDerivation {
      name = "qute-pass";
      propagatedBuildInputs = [
        (pkgs.python3.withPackages (pythonPackages:
          with pythonPackages; [
            tldextract
          ]))
      ];
      dontUnpack = true;
      installPhase = "install -Dm755 ${./userscripts/pass} $out/bin/pass";
    };
  in
    lib.mkIf config.browser.enable {
      programs.qutebrowser = {
        enable = true;
        settings = {
          tabs.show = "never";
          tabs.background = false;
          scrolling.bar = "never";
          content.blocking.method = "both";
        };
        keyBindings.normal = {
          "<Space>ff" = "cmd-set-text -s :tab-select";
          "<Space>g" = ":tab-give";
          "<Ctrl+o>" = ":tab-prev";
          "<Tab>" = ":tab-next";
          "<Space><p>" = ":spawn --userscript ${qutePass}/bin/pass  --username-target secret --username-pattern 'user: (.+)'";
        };
      };

      home.file.".config/qutebrowser/blocked-hosts".text = ''
        www.youtube.com
      '';
    };
}
