{
  description = "lentilus @ nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # fix GL
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    # fix spotlight and stuff on darwin
    mac-app-util = {
      url = "github:hraban/mac-app-util";
    };

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;

    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;

    sources = {
      dotfiles = ./config;
      scripts = ./config/scripts;
    };
  in {
    inherit sources;

    overlays = import ./overlays {inherit inputs;};
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    devShells = forAllSystems (system:
      import ./shells {
        inherit inputs outputs;
        pkgs = nixpkgs.legacyPackages.${system};
      });

    # custom modules
    homeManagerModules = import ./modules/home-manager;
    nixosModules = import ./modules/nixos;

    # personal
    nixosConfigurations."P14s-nixos" = inputs.nixpkgs.lib.nixosSystem {
      modules = [ ./hosts/P14s-nixos/configuration.nix ];
      specialArgs = {inherit inputs outputs;};
    };

    # work
    darwinConfigurations."JAAI-MBP-LP" = inputs.darwin.lib.darwinSystem {
      modules = [ ./hosts/JAAI-MBP-LP-darwin/configuration.nix ];
      specialArgs = {inherit inputs outputs;};
    };
  };
}
