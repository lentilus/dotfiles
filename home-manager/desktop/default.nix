{
  config,
  pkgs,
  lib,
  ...
}: {
    # we check if desktop is enabled in sway module
      imports = [
        ./sway.nix
      ];
}

