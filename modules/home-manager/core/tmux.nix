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
        extraConfig = ''
            unbind C-f
            bind-key -n C-f run-shell "tmux neww ~/.local/scripts/jump-tmux"
            bind -n M-H split-window -h -c "#{pane_current_path}"
            bind -n M-V split-window -v -c "#{pane_current_path}"
        '';
    };
  };
}
