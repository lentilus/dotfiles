pkgs: {
  withsc = pkgs.callPackage ./withsc.nix {};
  syshealth = pkgs.callPackage ./syshealth.nix {};
  jump = pkgs.callPackage ./jump.nix {};
  ppdir = pkgs.callPackage ./ppdir.nix {};
  previewpdf = pkgs.callPackage ./previewpdf.nix {};
  dlpdf = pkgs.callPackage ./dlpdf.nix {};
}
