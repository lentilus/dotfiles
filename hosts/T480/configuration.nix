{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    outputs.nixosModules
    ./hardware-configuration.nix
    ./powersaving.nix
    ../../features/nixpkgs.nix
    ../../features/nixos/login-window-manager.nix
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

  programs.zsh.enable = true;

  networking = {
    # allows undeclarative network settings
    # as opposed to `wireless.enable` for declaritive wpa_supplicant
    networkmanager.enable = true;
    hostName = "T480";
  };

  services = {
    pcscd.enable = true;
    tlp.enable = true;
    dbus.enable = true;

    # custom services
    backlight.enable = true;
    homeRowMods.enable = true;
    audio.enable = true;
  };

  services.searx = {
    enable = true;
    settings = {
      server = {
        port = 2987;
        bind_address = "127.0.0.1";
        secret_key = "secret key";
        limiter = false;
        default_http_headers.Access-Control-Allow-Origin = "*";
      };
      search.formats = ["json"];
    };
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
