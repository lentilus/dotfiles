{pkgs, ...}: {
  home.packages = [
    pkgs.nvim-pkg
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.mimeApps.defaultApplications = let
    nvim = "nvim.desktop";
  in {
    "text/plain" = nvim;
    "text/markdown" = nvim;
    "application/json" = nvim;
    "application/xml" = nvim;
  };
}
