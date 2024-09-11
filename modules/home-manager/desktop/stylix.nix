{
  lib,
  config,
  pkgs,
  ...
}: {
  stylix = {
    polarity = "dark";
    image = ./wallpaper.jpg;
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    # by hardcoding we can access the colors elsewhere
    base16Scheme = {
      base00 = "1d2021"; # ----
      base01 = "3c3836"; # ---
      base02 = "504945"; # --
      base03 = "665c54"; # -
      base04 = "bdae93"; # +
      base05 = "d5c4a1"; # ++ # gray??
      base06 = "ebdbb2"; # +++
      base07 = "fbf1c7"; # ++++
      base08 = "fb4934"; # red
      # base08 = "fe8000"; # new red
      base09 = "fe8019"; # orange
      base0A = "fabd2f"; # yellow
      base0B = "b8bb26"; # green
      base0C = "8ec07c"; # aqua/cyan
      base0D = "83a598"; # blue
      base0E = "d3869b"; # purple
      base0F = "d65d0e"; # brown

      # base00= "1e1e2e"; # base
      # base01= "181825"; # mantle
      # base02= "313244"; # surface0
      # base03= "45475a"; # surface1
      # base04= "585b70"; # surface2
      # base05= "cdd6f4"; # text
      # base06= "f5e0dc"; # rosewater
      # base07= "b4befe"; # lavender
      # base08= "f38ba8"; # red
      # base09= "fab387"; # peach
      # base0A= "f9e2af"; # yellow
      # base0B= "a6e3a1"; # green
      # base0C= "94e2d5"; # teal
      # base0D= "89b4fa"; # blue
      # base0E= "cba6f7"; # mauve
      # base0F= "f2cdcd"; # flamingo
    };

    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        name = "JetBrainsMono Nerd Font Mono";
      };
    };
  };
}
