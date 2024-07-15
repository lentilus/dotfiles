{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.ranger
  ];

  home.file = {
    "${config.xdg.configHome}/ranger" = {
      source = ../../config/ranger;
      recursive = true;
    };
  };
}
