{
  config,
  lib,
  pkgs,
  ...
}: let
  # how much to undervolt (in mV)
  cpuUndervolt = -100;
in {
  boot.kernelParams = lib.mkForce [
    # i915 power‑saving tweaks
    "i915.enable_psr=1"
    "i915.enable_rc6=7"
    "intel_pstate=enable"
  ];

  services = {
    tlp.enable = true;

    # --- New undervolt service block ---
    undervolt = {
      enable = true; # turn on the undervolt daemon :contentReference[oaicite:0]{index=0}
      coreOffset = cpuUndervolt; # offset for CPU cores (in mV)
      uncoreOffset = cpuUndervolt; # offset for the uncore/cache planes
      gpuOffset = cpuUndervolt; # offset for the integrated GPU
      analogioOffset = cpuUndervolt; # offset for analog I/O (uncore rail)
      useTimer = true; # re‑apply every 30 s (works around resume) :contentReference[oaicite:1]{index=1}
      verbose = true; # log your offsets at startup
      # turbo = 1;                           # you can also disable Turbo Boost if needed
      # tempTarget = 80;                     # or set a temperature ceiling (in °C)
    };

    # Hybrid‑sleep: suspend then hibernate after 30 minutes
    logind.extraConfig = ''
      HandleLidSwitch=hybrid-sleep
      IdleAction=hybrid-sleep
      IdleActionSec=5min
    '';
  };

  services.tlp.extraConfig = ''
    # Bluetooth off by default
    DEVICES_TO_DISABLE_ON_STARTUP="bluetooth"
    # suspend idle USB ports
    USB_AUTOSUSPEND=1
    # aggressive SATA/NVMe power‑management
    SATA_LINKPWR_ON_BAT=min_power
    RUNTIME_PM_ON_BAT=auto
  '';

  environment.systemPackages = with pkgs; [
    powertop
  ];

  systemd.services.powertop-tune = {
    description = "Run powertop --auto-tune at boot";
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${pkgs.powertop}/bin/powertop --auto-tune";
    # install.wantedBy = [ "multi-user.target" ];
  };
}
