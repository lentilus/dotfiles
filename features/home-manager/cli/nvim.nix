{pkgs, ...}: {
  home.packages = [
    pkgs.nvim-pkg
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
