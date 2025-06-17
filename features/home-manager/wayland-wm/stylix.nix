{pkgs, ...}: {
  stylix = {
    enable = true;
    polarity = "light";
    image = ./wallpaper.jpg;

    # by hardcoding we can access the colors elsewhere
    base16Scheme = {
      # base00 = "1d2021"; # ----
      # base01 = "3c3836"; # ---
      # base02 = "504945"; # --
      # base03 = "665c54"; # -
      # base04 = "bdae93"; # +
      # base05 = "d5c4a1"; # ++ # gray??
      # base06 = "ebdbb2"; # +++
      # base07 = "fbf1c7"; # ++++
      # base08 = "fb4934"; # red
      # base09 = "fe8019"; # orange
      # base0A = "fabd2f"; # yellow
      # base0B = "b8bb26"; # green
      # base0C = "8ec07c"; # aqua/cyan
      # base0D = "83a598"; # blue
      # base0E = "d3869b"; # purple
      base00 = "f2e5bc"; # ----
      base01 = "ebdbb2"; # ---
      base02 = "d5c4a1"; # --
      base03 = "bdae93"; # -
      base04 = "665c54"; # +
      base05 = "504945"; # ++
      base06 = "3c3836"; # +++
      base07 = "282828"; # ++++
      base08 = "9d0006"; # red
      base09 = "af3a03"; # orange
      base0A = "b57614"; # yellow
      base0B = "79740e"; # green
      base0C = "427b58"; # aqua/cyan
      base0D = "076678"; # blue
      base0E = "8f3f71"; # purple
      base0F = "d65d0e"; # brown
    };

    fonts = {
      monospace = {
        package = pkgs.unstable.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sizes = {
        applications = 10;
        desktop = 12;
      };
    };
  };
}
