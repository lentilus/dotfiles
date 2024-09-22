{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./sway.nix
    ./sway-services.nix
    ./kanshi.nix
    ./waybar.nix
  ];

  options = {
    sway.enable = lib.mkEnableOption "enable sway desktop";
  };

  config = lib.mkIf config.sway.enable {
    # start sway on tty login
    programs.zsh.profileExtra = ''
      # start sway if not running
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
          exec  ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.sway}/bin/sway
      fi
    '';

    # we source .profile on login in .zprofile
    kanshi.enable = lib.mkDefault true;
  };
}
