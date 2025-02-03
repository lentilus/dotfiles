pkgs: {
  withsc = pkgs.callPackage ./withsc.nix { };
  syshealth = pkgs.callPackage ./syshealth.nix { };
}
