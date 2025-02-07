{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [ ];

  shellHook = ''
    echo "Welcome to your development shell!"
  '';
}
