{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  services.nix-daemon.enable = true;

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    overlays = [
      # outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  programs.zsh.enable = true;
  system.defaults.universalaccess.reduceMotion = true;

  # make macos usable xD
  services.skhd = {
    enable = true;
    skhdConfig = ''
      cmd - a : open -a "kitty"
      cmd - s : open -a "qutebrowser"
      cmd - d : open -a "Microsoft Teams"
    '';
  };

  users.users."linuspreusser" = {
    name = "linuspreusser";
    home = "/Users/linuspreusser";
  };

  home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.linuspreusser = import ./home.nix;
      extraSpecialArgs = {inherit inputs outputs;};
  };

  system.stateVersion = 5;
}
