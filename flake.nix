{
  description = "Home Manager configuration of lentilus";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl.url = "github:nix-community/nixGL";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixgl, home-manager, ... }:
    let
        pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ nixgl.overlay ];
        };
      # system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};

    in {
      homeConfigurations = {
      "lentilus" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
            ./home.nix
            ];

        # arguments to home.nix
        extraSpecialArgs = {
            dotfiles = ./config;
            scripts = ./scripts;
            userConfig = rec {
                name = "lentilus";
                home = "/home/${name}";
            };
        };
      };
    "root" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
            ./home.nix
            ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
            dotfiles = ./config;

            userConfig = {
                name = "root";
                home = "/root";
            };
        };
      };
    };
    };
}
