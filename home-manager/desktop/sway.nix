{
  config,
  pkgs,
  lib,
  sources,
  nixgl,
  ...
}: {
  options = {
    desktop.enable = lib.mkEnableOption "foo";
  };

  config = lib.mkIf config.desktop.enable {
    home.packages = [
      # desktop dependencies
      # nixgl.nixGLCommon
      pkgs.dunst
      pkgs.kanshi
      pkgs.waybar
      pkgs.autotiling
      pkgs.rofi
      # pkgs.sway
      pkgs.foot
      pkgs.pipewire
    ];

    home.file = {
      "${config.xdg.configHome}/sway".source = "${sources.dotfiles}/sway";
      "${config.xdg.configHome}/waybar".source = "${sources.dotfiles}/waybar";
      # "${config.xdg.configHome}/rofi".source = ../../config/rofi;
      "${config.xdg.configHome}/foot".source = "${sources.dotfiles}/foot";
    };
  };
}
