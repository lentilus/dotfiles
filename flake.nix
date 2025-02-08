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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim = {
      url = "github:lentilus/nvim-flake";
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
  in {
    overlays = import ./overlays {inherit inputs;};
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # custom modules
    homeManagerModules = import ./modules/home-manager;
    nixosModules = import ./modules/nixos;

    # dev shell
    devShells = forAllSystems (system: {
      default = import ./shell.nix { pkgs = nixpkgs.legacyPackages.${system};};
    });

    # personal
    nixosConfigurations."P14s-nixos" = inputs.nixpkgs.lib.nixosSystem {
      modules = [./hosts/P14s-nixos/configuration.nix];
      specialArgs = {inherit inputs outputs;};
    };

  };
}
