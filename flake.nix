{
  description = "lentilus @ nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl.url = "github:nix-community/nixGL"; # openGL wrapper (necessary as of now)
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixgl,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    deployments = {
      "lentilus@fedora" = {system = "x86_64-linux";};
      "foo@bar" = {system = "x86_64-linux";};
    };

    systems = nixpkgs.lib.mapAttrsToList (usr: conf: conf.system) deployments;
    users = nixpkgs.lib.mapAttrsToList (usr: conf: usr) deployments;
    forAllSystems = nixpkgs.lib.genAttrs systems;
    forAllUsers = nixpkgs.lib.genAttrs users;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    homeConfigurations = forAllUsers (user:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          legacyPackages = deployments.${user}.system; # Home-manager requires 'pkgs' instance
          overlays = [nixgl.overlay];
        };

        extraSpecialArgs = {
          inherit inputs outputs;
          dotfiles = ./config;
          scripts = ./scripts;
          userConfig = rec {
            name = builtins.head (nixpkgs.lib.splitString "@" "${user}");
            home = "/home/${name}";
          };
        };

        modules = [
          ./home.nix
        ];
      });
  };
}
