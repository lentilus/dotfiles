pkgs: let
  sc = "${pkgs.withsc}/bin/withsc";
in {
  personal = {
    remote = {
      type = "caldav";
      url = "https://dav.mailbox.org/caldav/Y2FsOi8vMC8zMQ";
      userName = "linus.preusser@mailbox.org";
      passwordCommand = [ sc "pass" "communication/calendar"];
    };
    vdirsyncer = {
      enable = true;
      auth = "basic";
      collections = null;
      metadata = ["color"];
    };
    khal.enable = true;
  };
}
