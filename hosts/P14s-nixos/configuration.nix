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
    outputs.nixosModules
    ./hardware-configuration.nix
    ../../features/nixpkgs.nix
    ../../features/nixos/login-window-manager.nix
  ];

  # bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  programs.zsh.enable = true;

  # networking
  networking = {
    hostName = "P14s-nixos";
    networkmanager.enable = true;
  };

  services = {
    pcscd.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
    tlp.enable = true;

    # custom services
    polkit-authentication.enable = true;
    backlight.enable = true;
    homeRowMods.enable = true;
    audio.enable = true;
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
      "video" # light
    ];
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
