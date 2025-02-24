{
  pkgs,
  lib,
  config,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    config = let
      mod = "Mod4";
      rofi = "${config.programs.rofi.package}/bin/rofi";
      rofi-pass = "${config.programs.rofi.pass.package}/bin/rofi-pass";
      pamixer = "${pkgs.pamixer}/bin/pamixer";
      onempty = ws: app: ''swaymsg "[workspace=${ws}]" focus || ${app}'';
    in rec {
      modifier = mod;
      terminal = "kitty";
      menu = ''rofi -show drun'';
      window.titlebar = false;
      input."type:touchpad" = {
        dwt = "enabled";
        tap = "enabled";
        natural_scroll = "enabled";
        middle_emulation = "disabled";
      };
      output."*".scale = "1.4";
      keybindings = lib.mkOptionDefault {
        # unbind things
        "${mod}+s" = null;
        "${mod}+a" = null;
        "${mod}+Space" = null;

        "${mod}+1" = ''workspace 1; exec ${onempty "1" "${terminal} -- tmux a"}'';
        "${mod}+2" = ''workspace 2; exec ${onempty "2" "qutebrowser"}'';
        "${mod}+q" = "kill";

        "${mod}+w" = "exec ${rofi} -show window";
        "${mod}+x" = "exec ${rofi-pass}";
        "${mod}+g" = "exec ${pkgs.dlpdf}/bin/dlpdf";
        "XF86AudioLowerVolume" = "exec ${pamixer} -i 5";
        "XF86AudioRaiseVolume" = "exec ${pamixer} -d 5";
        "XF86AudioMute" = "exec ${pamixer} -t";
      };
    };
  };
}
