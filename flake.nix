{
  description = "lentilus @ nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    # flake-parts.url = "github:hercules-ci/flake-parts";
    # flake-utils.url = "github:numtide/flake-utils";
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
    nixgl.url = "github:nix-community/nixGL"; # openGL wrapper (necessary as of now)
  };

  outputs = {
    self,
    nixpkgs,
    nixgl,
    home-manager,
    home-manager-shell,
    flake-utils,
    ...
  } @ inputs: let
    inherit (self) outputs;

    deployments = {
      "lentilus@fedora" = {sys = "x86_64-linux";};
      "foo@bar" = {sys = "x86_64-linux";};
      "vscode" = {sys = "x86_64-linux";};
    };

    # needed for resolving imports
    sources = {
      dotfiles = ./config;
      scripts = ./config/scripts;
    };

    systems = nixpkgs.lib.mapAttrsToList (_: conf: conf.sys) deployments;
    users = nixpkgs.lib.mapAttrsToList (usr: _: usr) deployments;
    shortUsers = nixpkgs.lib.mapAttrsToList (usr: _: builtins.head (nixpkgs.lib.splitString "@" "${usr}")) deployments;

    # attribute maps
    forAllSystems = nixpkgs.lib.genAttrs systems;
    forAllUsers = nixpkgs.lib.genAttrs users;
    forAllShortUsers = nixpkgs.lib.genAttrs shortUsers;
  in {
    formatter = forAllSystems (sys: nixpkgs.legacyPackages.${sys}.alejandra);

    # homeManagerModules = import ./modules/home-manager;

    apps = forAllSystems (
      system: {
        # creates a shell in a temporary home uses
        # config from homeManagerProfiles
        tmp-shell = flake-utils.lib.mkApp {
          drv = home-manager-shell.lib {
            inherit self system;
            args.extraSpecialArgs = {
              inherit nixgl sources;
            };
          };
        };
      }
    );

    # import everything interesting from home-manager
    # that we want in tmp-shell
    # NOTE: we don't want/have to include everything from hm here!
    homeManagerProfiles = forAllShortUsers (user: {
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
        # Home-manager requires 'pkgs' instance
        pkgs = import nixpkgs {
          legacyPackages = deployments.${user}.system;
        };

        extraSpecialArgs = {
          inherit inputs outputs nixgl sources;
          # config.desktop.enable = false;
        };

        modules = [
          (
            if builtins.pathExists ./hosts/${user}/home.nix
            then ./hosts/${user}/home.nix
            else ./hosts/default/home.nix
          )

          (let
            shortUser = builtins.head (nixpkgs.lib.splitString "@" "${user}");
          in {
            home.username = shortUser;
            home.homeDirectory = "/home/${shortUser}";
          })
        ];
      });
  };
}
