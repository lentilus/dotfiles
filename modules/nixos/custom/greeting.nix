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
      hypr = pkgs.writeShellScriptBin "Hyprland" ''
        # make hm-variables available to hyprland session
        . "/etc/profiles/per-user/lentilus/etc/profile.d/hm-session-vars.sh"
        # UWSM_FINALIZE_VARNAMES needs to be seperated with spaces
        export UWSM_FINALIZE_VARNAMES="$${UWSM_FINALIZE_VARNAMES//:/ }"
        exec /run/current-system/sw/bin/Hyprland
      '';
    in ''
      if [ "$(tty)" = "/dev/tty1" ] && ${uwsm} check may-start; then
          exec ${uwsm} start ${hypr}/bin/Hyprland
      fi
    '';

    environment.sessionVariables = {
      UWSM_FINALIZE_VARNAMES = [
        "NIXOS_OZONE_WL"
        "PASSWORD_STORE_DIR"
        "TERMINAL"
        "VISUAL"
        "EDITOR"
        "BROWSER"
      ];
    };
  };
}
