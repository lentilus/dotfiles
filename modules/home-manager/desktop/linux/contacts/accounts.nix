pkgs: let
  sc = "${pkgs.withsc}/bin/withsc";
in {
  personal = {
    local = {
      type = "filesystem";
      fileExt = ".vcf";
    };

    remote = {
      type = "carddav";
      url = "https://dav.mailbox.org/carddav/32";
      userName = "linus.preusser@mailbox.org";
      passwordCommand = [sc "pass" "communication/contacts"];
    };
    vdirsyncer = {
      enable = true;
      auth = "basic";
      collections = null;
    };
    khard.enable = true;
  };
}
