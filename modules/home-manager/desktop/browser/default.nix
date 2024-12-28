{
  config,
  pkgs,
  lib,
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
      installPhase = "install -Dm755 ${./pass} $out/bin/pass";
    };
  in
    lib.mkIf config.browser.enable {
      programs.qutebrowser = {
        package = pkgs.unstable.qutebrowser;
        enable = true;
        settings = {
          tabs.show = "never";
          tabs.background = true; # I don't get it, but works (https://github.com/qutebrowser/qutebrowser/issues/3231)
          scrolling.bar = "never";
          content.blocking.method = "both";
          window.hide_decoration = true;
          content.javascript.clipboard = "access";
          url.start_pages = ["about:blank"];
          colors.webpage.darkmode.enabled = false;
        };
        searchEngines = lib.mkDefault {
          DEFAULT = "https://www.duckduckgo.com/?q={}";
          g = "https://www.google.com/search?q={}";
          w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
          hm = "https://home-manager-options.extranix.com/?query={}&release=master";
          np = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
          yt = "https://www.youtube.com/results?search_query={}";
          gpt = "https://chatgpt.com/?q={}";
          gh = "https://github.com/search?q=user:lentilus {}";
        };
        keyBindings.normal = {
          "<Space>ff" = "cmd-set-text -s :tab-select";
          "<Space>g" = ":tab-give";
          "<Ctrl+o>" = ":tab-prev";
          "<Tab>" = ":tab-next";
          "<Space><p>" = ":spawn --userscript ${qutePass}/bin/pass  --username-target secret --username-pattern 'user: (.+)'";
          "<Space><u><p>" = ":spawn --userscript ${qutePass}/bin/pass --username-only --username-target secret --username-pattern 'user: (.+)'";
          "<Space><j><p>" = ":spawn --userscript ${qutePass}/bin/pass --password-only --username-target secret --username-pattern 'user: (.+)'";
        };
      };

      home.file.".config/qutebrowser/blocked-hosts".text = ''
      '';
      # www.youtube.com
    };
}
