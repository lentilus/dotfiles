{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    nix
    nixd
    nixos-rebuild
  ];
  
  shellHook = ''
    echo "Welcome to your development shell!"
    export NIX_CONFIG="experimental-features = nix-command flakes"
  '';
}
