pkgs: {
  jump = pkgs.callPackage ./jump.nix {};
  ppdir = pkgs.callPackage ./ppdir.nix {};
  previewpdf = pkgs.callPackage ./previewpdf.nix {};
  dlpdf = pkgs.callPackage ./dlpdf.nix {};
  pass-gocrypt = pkgs.callPackage ./pass-gocrypt.nix {pass_gocrypt_timeout = "9999999999999";};
}
