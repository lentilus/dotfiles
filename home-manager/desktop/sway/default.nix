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
    # ./sway-bar.nix
    ./waybar.nix
  ];

  options = {
    sway.enable = lib.mkEnableOption "enable sway desktop";
  };

  config = lib.mkIf config.sway.enable {
    # we source .profile on login in .zprofile
    home.file.".profile".text = ''
      # start sway if not running
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
          exec  ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.sway}/bin/sway
      fi
    '';
  };
}
