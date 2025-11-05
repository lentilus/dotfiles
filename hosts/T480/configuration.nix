{
  inputs,
  outputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    outputs.nixosModules
    ./hardware-configuration.nix
    ../../features/nixos/login-window-manager.nix
    ../../features/nixos/search-engnine.nix
  ];

  boot = {
    # https://github.com/NixOS/nixpkgs/issues/342082
    initrd = {
      systemd.enable = true;
      luks.devices.cryptroot.device = "/dev/disk/by-uuid/8f424f87-b2e1-4128-92a1-d3ae8fcc3928";
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  sops.age.keyFile = "/home/lentilus/.config/sops/age/keys.txt";

  networking = {
    # allows undeclarative network settings
    # as opposed to `wireless.enable` for declaritive wpa_supplicant
    networkmanager.enable = true;
    hostName = "T480";
  };

  # wireguard vpn setup
  sops.secrets.wg-config = {
    sopsFile = ../../secrets/wireguard.conf;
    format = "binary";
  };
  networking.wg-quick.interfaces.wg0 = {
    autostart = true;
    configFile = config.sops.secrets."wg-config".path;
  };

  programs.zsh.enable = true;

  services = {
    pcscd.enable = true;
    tlp.enable = true;
    dbus.enable = true;
    udisks2.enable = true; # calibre

    # custom services
    backlight.enable = true;
    homeRowMods.enable = true;
    audio.enable = true;
  };

  security.polkit.enable = true;

  time.timeZone = "Europe/Berlin";

  home-manager = {
    useGlobalPkgs = true;
    users.lentilus = import ./home.nix;
    extraSpecialArgs = {inherit inputs outputs;};
    backupFileExtension = "backup";
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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
