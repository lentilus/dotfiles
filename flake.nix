{
  description = "lentilus @ nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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

    stylix.url = "github:danth/stylix";
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
      # "x86_64-darwin"
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

    homeManagerModules = import ./modules/home-manager;

    ### for non-nixos hosts
    homeConfigurations = {
      # must be built --impure as it needs access to $HOME, $USER
      default = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager
        ];
      };

      "lentilus@fedora" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/lentilus.nix
        ];
      };
    };

    ### for macos (work)
    darwinConfigurations."JAAI-MBP-LP" = inputs.darwin.lib.darwinSystem {
      modules = [
        ./darwin/configuration.nix
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.linuspreusser = import ./home-manager/macos.nix;
          home-manager.extraSpecialArgs = {inherit inputs outputs;};
        }
      ];
      specialArgs = {inherit inputs outputs;};
    };

    ### for nixos
    nixosConfigurations."nixolas" = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        ./nixos/configuration.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.lentilus = import ./home-manager/lentilus.nix;
          home-manager.extraSpecialArgs = {inherit inputs outputs;};
        }
      ];
      specialArgs = {inherit inputs outputs;};
    };
  };
}
