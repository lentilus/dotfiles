{
  description = "lentilus @ nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nvim.url = "github:lentilus/nvim-flake";

    # TODO: rm dependence on flake-utils 
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
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

    systems = [
      "x86_64-linux"
      # "aarch64-darwin"
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
      default = import ./shell.nix {pkgs = nixpkgs.legacyPackages.${system};};
    });

    # personal
    nixosConfigurations."P14s-nixos" = inputs.nixpkgs.lib.nixosSystem {
      modules = [./hosts/P14s-nixos/configuration.nix];
      specialArgs = {inherit inputs outputs;};
    };

    apps = forAllSystems (system: {
      # proot shell
      shell = inputs.flake-utils.lib.mkApp {
        drv = import ./proot-shell.nix {
          home-manager = inputs.home-manager;
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./features/home-manager/cli
            {
              nixpkgs = {
                overlays = [
                  inputs.nvim.overlays.default
                  outputs.overlays.additions
                  outputs.overlays.modifications
                  outputs.overlays.unstable-packages
                ];
              };
            }
          ];
        };
      };
    });
  };
}
