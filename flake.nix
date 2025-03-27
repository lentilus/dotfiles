{
  description = "lentilus @ nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nvim.url = "github:lentilus/nvim-flake";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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

    systems = ["x86_64-linux"];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    overlays = import ./overlays {inherit inputs;};
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    homeManagerModules = import ./modules/home-manager;
    nixosModules = import ./modules/nixos;

    devShells = forAllSystems (system: {
      default = import ./shell.nix {pkgs = nixpkgs.legacyPackages.${system};};
    });

    nixosConfigurations = {
      "T480" = inputs.nixpkgs.lib.nixosSystem {
        modules = [./hosts/T480/configuration.nix];
        specialArgs = {inherit inputs outputs;};
      };
    };

    packages = forAllSystems (system: {
      shell = import ./proot-shell.nix {
        home-manager = inputs.home-manager;
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./features/home-manager/cli
          ./features/nixpkgs.nix
        ];
      };
    });
  };
}
