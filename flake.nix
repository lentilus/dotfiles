{
  description = "lentilus @ nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-shell = {
      url = "sourcehut:~dermetfan/home-manager-shell/release-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    home-manager-shell,
    flake-utils,
    ...
  } @ inputs: let
    inherit (self) outputs;

    deployments = {
      "lentilus" = {sys = "x86_64-linux";};
      "foo" = {sys = "x86_64-linux";};
      "vscode" = {sys = "x86_64-linux";}; # for devcontainers
    };

    # needed for resolving imports
    sources = {
      dotfiles = ./config;
      scripts = ./config/scripts;
    };

    systems = nixpkgs.lib.mapAttrsToList (_: conf: conf.sys) deployments;
    users = nixpkgs.lib.mapAttrsToList (usr: _: usr) deployments;

    # attribute maps
    forAllSystems = nixpkgs.lib.genAttrs systems;
    forAllUsers = nixpkgs.lib.genAttrs users;
  in {
    formatter = forAllSystems (sys: nixpkgs.legacyPackages.${sys}.alejandra);

    apps = forAllSystems (
      system: {
        # creates a shell in a temporary home uses
        # config from homeManagerProfiles
        tmp-shell = flake-utils.lib.mkApp {
          drv = home-manager-shell.lib {
            inherit self system;
            args.extraSpecialArgs = {
              # inherit nixgl;
              inherit sources;
            };
          };
        };
      }
    );

    # import everything interesting from home-manager
    # that we want in tmp-shell
    # NOTE: we don't want/have to include everything from hm here!

    homeManagerProfiles = forAllUsers (user: {
      imports = [
        (
          if builtins.pathExists ./hosts/${user}/home.nix
          then ./hosts/${user}/home.nix
          else ./hosts/default/home.nix
        )
      ];
    });

    homeConfigurations = forAllUsers (user: 
        home-manager.lib.homeManagerConfiguration
        {
        pkgs = let
            system=deployments.${user}.sys;
        in
        nixpkgs.legacyPackages.${system};

        extraSpecialArgs = {
            inherit inputs outputs sources;
        };

        modules = [
          (
            if builtins.pathExists ./hosts/${user}/home.nix
            then ./hosts/${user}/home.nix
            else ./hosts/default/home.nix
          )

          {
            home.username = "${user}";
            home.homeDirectory = "/home/${user}";
          }

        ];
    });
  };
}
