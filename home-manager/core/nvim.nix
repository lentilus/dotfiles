{
  config,
  pkgs,
  sources,
  lib,
  ...
}: {
  options = {
    nvim.enable = lib.mkEnableOption "foo";
  };

  config = lib.mkIf config.nvim.enable {
      home.packages = [
        # plugin dependencies
        pkgs.fd
        pkgs.ripgrep
        pkgs.cargo
        pkgs.neovim
      ];

      home.file = {
        "${config.xdg.configHome}/nvim" = {
            source = "${sources.dotfiles}/nvim";
            recursive = true;
            onChange = ''
                echo "copying lazy-lock file"
                rm -rf ${config.xdg.configHome}/nvim/lazy-lock.json
                cp ${config.xdg.configHome}/nvim/lazy-lock.json.bak ${config.xdg.configHome}/nvim/lazy-lock.json
            '';
        };
      };
  };
}
