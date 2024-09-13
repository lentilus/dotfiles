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
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      prefix = "C-Space";
      shell = "${pkgs.zsh}/bin/zsh";
      newSession = true;
      escapeTime = 0;
      plugins = [
        pkgs.tmuxPlugins.vim-tmux-navigator
      ];
      extraConfig = let
        jump = pkgs.writeShellScriptBin "jump-tmux" ''
          #!/bin/bash
          # Heavily inspired by ThePrimagen's tmux sessionizer

          target="$HOME/git"
          selecthook='nvim -c "normal -"; $SHELL'

          if [[ $# -eq 1 ]]; then
              selected=$1
          else
              cd "$HOME/git" || exit
              selected=$(${pkgs.findutils}/bin/find $target -maxdepth 1 -type d -printf '%P\n' | fzf)
          fi

          if [[ -z $selected ]]; then
              exit 0
          fi

          selected_name=$(basename "$selected" | tr . _)

          if ! tmux has-session -t="$selected_name" 2> /dev/null; then
              tmux new-session -ds "$selected_name" -c "$selected" "$selecthook"
          fi

          tmux switch-client -t "$selected_name"
        '';
      in ''
        unbind C-f
        bind-key -n C-f run-shell "tmux neww ${jump}/bin/jump-tmux"
        bind -n M-H split-window -h -c "#{pane_current_path}"
        bind -n M-V split-window -v -c "#{pane_current_path}"

        set -g default-terminal "xterm-256color"
        set-option -ga terminal-overrides ",xterm-256color:Tc
      '';
        # set -as terminal-overrides ",tmux*:Tc"
    };
  };
}
