{pkgs, ...}: {
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = ["zathura.desktop"];
    };
    defaultApplications = {
      "application/pdf" = ["zathura.desktop"];
    };
  };
}
