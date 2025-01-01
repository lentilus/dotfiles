{
  core = import ./core;
  dev = import ./dev;
  desktop = import ./desktop;
  darwinDesktop = import ./darwinDesktop;
  ssh = import ./ssh;
  homeConfig = import ./homeConfig.nix;
  yubikeyGpg = import ./yubikeyGpg.nix;
}
