{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  nvim = pkgs.mkShell {
    buildInputs = with pkgs; [
      neovim
      fd
      ripgrep
      nodejs
      cargo
    ];

    shellHook = ''
      # Set isolated XDG paths for Neovim
      export XDG_CONFIG_HOME=$(mktemp -d)
      export XDG_DATA_HOME=$(mktemp -d)
      export XDG_STATE_HOME=$(mktemp -d)
      export XDG_CACHE_HOME=$(mktemp -d)

      # Link Neovim configuration from flake sources
      ln -s ${inputs.self.outputs.sources.dotfiles}/nvim $XDG_CONFIG_HOME/nvim

      # Cleanup on exit
      cleanup() {
        rm -rf "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME"
      }
      trap cleanup EXIT
    '';
  };
}
