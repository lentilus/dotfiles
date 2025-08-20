{
  programs = {
    khard.enable = true;
  };

  accounts.contact = {
    basePath = "Contacts";
    accounts.personal = {
      local = {
        type = "filesystem";
        fileExt = ".vcf";
      };
      khard.enable = true;
    };
  };
}
