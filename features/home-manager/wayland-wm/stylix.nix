{pkgs, ...}: {
  stylix = {
    enable = true;
    polarity = "light";
    image = ./wallpaper.jpg;

    # by hardcoding we can access the colors elsewhere
    base16Scheme = {
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
