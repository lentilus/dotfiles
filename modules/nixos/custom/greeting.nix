{
  config,
  pkgs,
  lib,
  outputs,
  ...
}: let
  cfg = config.custom.greeting;
in {
  options.custom.greeting = {
    enable = lib.mkEnableOption "start hyprland via uwsm on tty1-login";
  };
  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = false; # we manage it ourselves
    };

    # https://github.com/Vladimir-csp/uwsm
    programs.uwsm = {
      enable = true;
      waylandCompositors = {};
    };

    # auto start Hyprland via uwsm on tty1-login
    environment.shellInit = let
      uwsm = "${config.programs.uwsm.package}/bin/uwsm";
      hypr = pkgs.pkgs.writeShellScriptBin "Hyprland" ''
        # make hm-variables available to hyprland session
        . "/etc/profiles/per-user/lentilus/etc/profile.d/hm-session-vars.sh"
        exec /run/current-system/sw/bin/Hyprland
      '';
    in ''
      if [ "$(tty)" = "/dev/tty1" ] && ${uwsm} check may-start; then
          exec ${uwsm} start ${hypr}/bin/Hyprland
      fi
    '';

    environment.sessionVariables = {
      # force electron / chromium apps to use wayland
      NIXOS_OZONE_WL = "1";

      # varnames to expose to systemd services via uwsm
      UWSM_FINALIZE_VARNAMES = "TERMINAL NIXOS_OZONE_WL PASSWORD_STORE_DIR "; # leave a space!!!
    };
  };
}
