{pkgs, ...}: {
  home.packages = [
    pkgs.coreutils
    pkgs.locale
    pkgs.fzf
    pkgs.nvim-pkg
    pkgs.ripgrep
    pkgs.tree

    # little scripts
    pkgs.previewpdf
    pkgs.ppdir
  ];

  # shell
  programs.zsh = {
    enable = true;
    completionInit = "autoload -U compinit && compinit -C -u";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      vi = "nvim";
      c = "clear";
      ls = "ls -A --color";
      fw = "cd $(git worktree list | fzf | awk '{print $1;}') || :";
      nd = "nix develop --command zsh";
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
    "$HOME/.local/bin" # pipx
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
