{
  config,
  pkgs,
  ...
} @ inputs: {
  imports = [
    ../default/home.nix
  ];

  desktop.enable = true;
  dev.enable = true;
}
