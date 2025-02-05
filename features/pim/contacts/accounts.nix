{
  personal = {
    local = {
      type = "filesystem";
      fileExt = ".vcf";
    };

    remote = {
      type = "carddav";
      url = "https://dav.mailbox.org/carddav/32";
      userName = "linus.preusser@mailbox.org";
      passwordCommand = ["withsc" "pass" "communication/contacts"];
    };
    vdirsyncer = {
      enable = true;
      auth = "basic";
      collections = null;
    };
    khard.enable = true;
  };
}
