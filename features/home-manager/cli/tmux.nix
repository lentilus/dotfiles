{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    prefix = "C-Space";
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

      # nvim :checkhealth
      set-option -g focus-events on

      unbind C-f
      bind-key -n C-f run-shell "tmux neww ${pkgs.jump}/bin/jump"
      bind-key -n M-Space previous-window
      bind -n M-H split-window -h -c "#{pane_current_path}"
      bind -n M-V split-window -v -c "#{pane_current_path}"
      bind  c  new-window      -c "#{pane_current_path}"

      set-hook -g session-created 'rename-window -t 0 EDITOR; send-keys -t EDITOR "$EDITOR" C-m; new-window -n SHELL -c "#{pane_current_path}";'

      # Set Alt-a to switch to the EDITOR window
      bind -n M-a select-window -t EDITOR

      # Set Alt-s to switch to the SHELL window
      bind -n M-s select-window -t SHELL

      # Ensure the first window is always EDITOR
      set-option -g renumber-windows on
    '';
  };
}
