{
  config,
  pkgs,
  lib,
  outputs,
  ...
}: {
  options = {
    zsh.enable = lib.mkEnableOption "enable zsh shell along with core utils and git";
  };

  config = lib.mkIf config.zsh.enable {
    home.packages = [
      pkgs.coreutils
      pkgs.locale
      pkgs.git
      pkgs.fzf
      pkgs.nvim-pkg
      pkgs.ripgrep
    ];

    # shell
    programs.zsh = {
      enable = true;
      completionInit = ''
        # load completions in background
        autoload -U compinit && compinit -C -u
      '';
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        vi = "nvim";
        c = "clear";
        ls = "ls -A --color";
        fw = "cd $(git worktree list | fzf | awk '{print $1;}')";
      };

      initExtraFirst = ''
        ### prompt START ###
        setopt prompt_subst
        autoload -Uz vcs_info
        precmd() { vcs_info }
        zstyle ':vcs_info:git:*' formats '(%b)'
        PROMPT='%F{blue}%~%f ''${vcs_info_msg_0_} > '
        ### prompt END ###
      '';

      initExtra = ''
        ### PLUGINS START ###
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        ### PLUGINS END ###

        # for quick hotfix situations
        [ -f $HOME/.extrazsh ] && source "$HOME/.extrazsh"
      '';
    };

    home.sessionPath = [
      "$HOME/.local/scripts" # personal scripts
      "$HOME/.local/bin" # pipx
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
