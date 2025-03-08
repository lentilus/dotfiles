{
  accounts.calendar = {
    accounts = import ./accounts.nix;
    basePath = "Calendar";
  };
  programs = {
    vdirsyncer.enable = true;
    khal.enable = true;
    todoman = {
      enable = true;
      extraConfig = ''
        default_list = "todo";
      '';
    };
  };
  services.vdirsyncer = {
    enable = true;
    frequency = "*:0/15";
  };
}
