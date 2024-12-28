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
    home-manager,
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
        inherit system inputs outputs;
        pkgs = nixpkgs.legacyPackages.${system};
      });

    homeManagerModules = import ./modules/home-manager;

    homeConfigurations = {
      # must be built --impure as it needs access to $HOME, $USER
      default = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager
        ];
      };

      "lentilus@fedora" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/lentilus.nix
        ];
      };

      # for work
      linuspreusser = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/macos.nix
        ];
      };
    };

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
  };
}
