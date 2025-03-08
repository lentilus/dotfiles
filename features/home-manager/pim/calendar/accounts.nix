let
  template = id: {
    remote = {
      type = "caldav";
      url = "https://dav.mailbox.org/caldav/${id}";
      userName = "linus.preusser@mailbox.org";
      passwordCommand = ["withsc" "pass" "communication/calendar"];
    };
    vdirsyncer = {
      enable = true;
      auth = "basic";
      collections = null;
      metadata = ["color"];
    };
    khal.enable = true;
  };
in {
  personal = template "Y2FsOi8vMC8zMQ";
  family = template "Y2FsOi8vMC80Mw";
  birthdays = template "Y2FsOi8vMS8w";
  todo = template "MzM" // {khal.enable = false;};
}
