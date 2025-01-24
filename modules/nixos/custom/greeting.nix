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
    enable = lib.mkEnableOption "enable greetd and uwsm based session management for hyprland";
  };
  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = false; # we manage it ourselves
    };

    # https://github.com/Vladimir-csp/uwsm
    programs.uwsm.enable = true;
    programs.uwsm.waylandCompositors = {};

    services.greetd = let
      uwsm = "${config.programs.uwsm.package}/bin/uwsm";
      startup = pkgs.pkgs.writeShellScriptBin "start" ''
        exec ${uwsm} start ${hypr}/bin/Hyprland || exec ${pkgs.zsh}/bin/zsh
      '';
      hypr = pkgs.pkgs.writeShellScriptBin "Hyprland" ''
        # make hm-variables available to hyprland session
        . "/etc/profiles/per-user/lentilus/etc/profile.d/hm-session-vars.sh"

        exec /run/current-system/sw/bin/Hyprland
      '';
    in {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${startup}/bin/start";
        };
      };
    };

    environment.sessionVariables = {
      # force electron / chromium apps to use wayland
      NIXOS_OZONE_WL = "1";

      # varnames to expose to systemd services via uwsm
      UWSM_FINALIZE_VARNAMES = "TERMINAL NIXOS_OZONE_WL PASSWORD_STORE_DIR "; # leave a space!!!
    };
  };
}
