{
  description = "lentilus @ nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim.url = "github:lentilus/nvim-flake";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;

    systems = ["x86_64-linux"];

    forAllSystems = nixpkgs.lib.genAttrs systems;
    
    pkgsFor = let
        ols = import ./overlays {inherit inputs;};
    in system:
     import inputs.nixpkgs {
       inherit system;
       config.allowUnfree = true;
       overlays = with ols; [ additions modifications unstable-packages ];
    };
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    nixpkgs = forAllSystems (system: pkgsFor system);

    homeManagerModules = import ./modules/home-manager;
    nixosModules = import ./modules/nixos;

    nixosConfigurations = {
      "T480" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = pkgsFor "x86_64-linux";
        modules = [ ./hosts/T480/configuration.nix ];
        specialArgs = {inherit inputs outputs;};
      };
    };

    packages = forAllSystems (system: {
      shell = import ./proot-shell.nix {
        home-manager = inputs.home-manager;
        pkgs = pkgsFor system;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [ ./features/home-manager/cli ];
      };
    });

    devShells = forAllSystems (system: {
      default = let
        pkgs = pkgsFor system;
      in
        pkgs.mkShell {
          buildInputs = with pkgs; [nix nixd nixos-rebuild sops];
          shellHook = ''
            export NIX_CONFIG="experimental-features = nix-command flakes"
          '';
        };
    });
  };
}
