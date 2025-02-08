{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    outputs.nixosModules.custom
    ./hardware-configuration.nix
  ];

  # bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # custom options
  custom = {
    greeting.enable = true;
    homeRowMods.enable = true;
    authentication.enable = true;
    audio.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autosuggestions.enable = false;
  };

  # power saving
  services.tlp.enable = true;

  # networking
  networking = {
    hostName = "P14s-nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Berlin";
  # home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.lentilus = import ./home.nix;
    extraSpecialArgs = {inherit inputs outputs;};
  };

  users.users.lentilus = {
    initialPassword = "correcthorsebatterystaple";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "input" # kanata
      "networkmanager"
    ];
  };

  nixpkgs = {
    overlays = [
      # inputs.nixgl.overlay
      inputs.nvim.overlays.default

      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
