{
  config,
  pkgs,
  outputs,
  lib,
  ...
}: {
  options = {
    nvim.enable = lib.mkEnableOption "foo";
  };

  config = lib.mkIf config.nvim.enable {
    home.packages = [
      # plugin dependencies
      pkgs.gcc
      pkgs.fd
      pkgs.ripgrep
      pkgs.cargo
      pkgs.unstable.neovim
      pkgs.nodejs # to install LSPs

      # language servers
      pkgs.nixd
      pkgs.tinymist
      pkgs.lua-language-server
      pkgs.tinymist
      pkgs.gopls

      # formatters
      pkgs.typstfmt
      pkgs.stylua
      pkgs.black
      pkgs.gofumpt
      pkgs.goimports-reviser
      pkgs.golines
      pkgs.texlivePackages.latexindent
    ];

    home.file = {
      "${config.xdg.configHome}/nvim" = {
        source = "${outputs.sources.dotfiles}/nvim";
        recursive = true;
        onChange = ''
          echo "copying lazy-lock file"
          rm -rf ${config.xdg.configHome}/nvim/lazy-lock.json
          cp ${config.xdg.configHome}/nvim/lazy-lock.json.bak ${config.xdg.configHome}/nvim/lazy-lock.json
          chmod u+w ${config.xdg.configHome}/nvim/lazy-lock.json
        '';
      };
    };
  };
}
