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

      keybindings = lib.mkOptionDefault {
        "${mod}+Shift+d" = ''exec ${rofi} -dmenu -p "nix-shell:" | xargs -I {} nix-shell -p {} --command {}'';
        "${mod}+1" = ''workspace 1; exec ${onempty "1" "${terminal} -- tmux a"}'';
        "${mod}+2" = ''workspace 2; exec ${onempty "2" "qutebrowser about:blank"}'';
        "${mod}+q" = "kill";

        "${mod}+w" = "exec ${rofi} -show window";
        "${mod}+x" = "exec ${rofi-pass}";
        "${mod}+t" = "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.wl-clipboard}/bin/wl-copy";
        "${mod}+g" = "exec ${pkgs.dlpdf}/bin/dlpdf";

        "XF86AudioLowerVolume" = "exec ${pamixer} -d 5";
        "XF86AudioRaiseVolume" = "exec ${pamixer} -i 5";
        "XF86AudioMute" = "exec ${pamixer} -t";
      };
    };
  };
}
