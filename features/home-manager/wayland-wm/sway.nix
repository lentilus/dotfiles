{
  pkgs,
  lib,
  config,
  ...
}: {
  wayland.windowManager.sway = {
    systemd = {
      enable = true;
    };
    enable = true;
    config = let
      mod = "Mod4";
      onempty = ws: app: ''swaymsg "[workspace=${ws}]" focus || ${app}'';

      # menus
      rofi = "${config.programs.rofi.package}/bin/rofi";
      rofi-pass = "${config.programs.rofi.pass.package}/bin/rofi-pass";

      # media controls
      volumeUp = "${pkgs.pamixer}/bin/pamixer -i 5";
      volumeDown = "${pkgs.pamixer}/bin/pamixer -d 5";
      volumeMute = "${pkgs.pamixer}/bin/pamixer -t";
    in rec {
      modifier = mod;
      defaultWorkspace = "workspace number 1";
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

        # workspace bindings
        "${mod}+1" = ''workspace 1; exec ${onempty "1" "${terminal} -- tmux a"}'';
        "${mod}+2" = ''workspace 2; exec ${onempty "2" "qutebrowser"}'';

        "${mod}+q" = "kill";
        "${mod}+Shift+q" = "uwsm stop";
        "${mod}+w" = "exec ${rofi} -show window";
        "${mod}+x" = "exec ${rofi-pass}";
        "${mod}+g" = "exec ${pkgs.dlpdf}/bin/dlpdf";

        # media keys
        "XF86AudioLowerVolume" = "exec ${volumeDown}";
        "XF86AudioRaiseVolume" = "exec ${volumeUp}";
        "XF86AudioMute" = "exec ${volumeMute}";
      };
    };
  };
}
