{
  config,
  pkgs,
  lib,
  ...
}: {
  home.sessionVariables = {
    BROWSER = lib.mkDefault "qutebrowser";
  };

  programs.qutebrowser = {
    # package = lib.mkDefault pkgs.unstable.qutebrowser;
    package = lib.mkDefault pkgs.qutebrowser;
    enable = true;
    greasemonkey = [
      (pkgs.writeText "strip-duckduckgo.js" (builtins.readFile ./minimal-duckduckgo.js))
    ];
    settings = {
      scrolling.bar = "never";
      window.hide_decoration = true;
      url.start_pages = ["about:blank"];
      colors.webpage.darkmode.enabled = false;

      content = {
        blocking.method = "both";
        javascript.clipboard = "access";
        local_content_can_access_remote_urls = true;
      };

      tabs = {
        # https://github.com/qutebrowser/qutebrowser/issues/3231
        background = true;
        show = "never";
      };
    };
    searchEngines = lib.mkDefault {
      DEFAULT = "https://html.duckduckgo.com/html/?q={}";
      g = "https://www.google.com/search?q={}";
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      hm = "https://home-manager-options.extranix.com/?query={}&release=master";
      np = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      yt = "https://www.youtube.com/results?search_query={}";
      gpt = "https://chatgpt.com/?q={}";
    };
    keyBindings.normal = {
      "<Space>ff" = "cmd-set-text -s :tab-select";
      "<Space>g" = ":tab-give";
      "<Ctrl+o>" = ":tab-prev";
      "<Ctrl+i>" = ":tab-next";
      "<Tab>" = ":tab-next";
      ",o" = "spawn xdg-open {url}";
      ",O" = "hint links spawn xdg-open {url}";
      ",m" = "spawn ${config.programs.mpv.package}/bin/mpv {url}";
      ",M" = "hint links spawn ${config.programs.mpv.package}/bin/mpv {url}";
    };
  };

  home.file.".config/qutebrowser/blocked-hosts".text = ''
  '';
  #  www.youtube.com

  xdg.mimeApps.defaultApplications = let
    qutebrowser = "org.qutebrowser.qutebrowser.desktop";
  in {
    "text/html" = qutebrowser;
    "image/png" = qutebrowser;
    "image/jpg" = qutebrowser;
    "image/jpeg" = qutebrowser;
    "x-scheme-handler/http" = qutebrowser;
    "x-scheme-handler/https" = qutebrowser;
    "x-scheme-handler/about" = qutebrowser;
    "x-scheme-handler/unknown" = qutebrowser;
  };
}
