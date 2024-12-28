{
  config,
  pkgs,
  lib,
  outputs,
  ...
}: {
  options = {
    tmux.enable = lib.mkEnableOption "foo";
  };

  config = lib.mkIf config.tmux.enable {
    programs.tmux = let
      jump = pkgs.stdenv.mkDerivation {
        name = "jumptmux";
        propagatedBuildInputs = [pkgs.findutils];
        dontUnpack = true;
        installPhase = "install -Dm755 ${./jump} $out/bin/jumptmux";
      };
    in {
      enable = true;
      keyMode = "vi";
      prefix = "C-Space";
      # shell = "${pkgs.zsh}/bin/zsh"; # broken, see https://github.com/nix-community/home-manager/issues/5952
      terminal = "screen-256color";
      newSession = true;
      escapeTime = 0;
      aggressiveResize = true;
      secureSocket = false; # to survive logout
      plugins = [
        pkgs.tmuxPlugins.vim-tmux-navigator
      ];
      extraConfig = ''
        set -ag terminal-overrides ",*:Tc" # true color
        set -ag terminal-overrides ',*:cud1=\E[1B' # fix splits in ssh

        # https://github.com/nix-community/home-manager/issues/5952
        set -gu default-command
        set -g default-shell "${pkgs.zsh}/bin/zsh"

        unbind C-f
        bind-key -n C-f run-shell "tmux neww ${jump}/bin/jumptmux"
        bind-key -n M-Space previous-window
        bind -n M-H split-window -h -c "#{pane_current_path}"
        bind -n M-V split-window -v -c "#{pane_current_path}"
        bind  c  new-window      -c "#{pane_current_path}"
      '';
    };
  };
}
