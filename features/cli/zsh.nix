{pkgs, ...}: {
  home.packages = [
    pkgs.coreutils
    pkgs.locale
    pkgs.fzf
    pkgs.nvim-pkg
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

    # do not source /etc/zshrc
    envExtra = ''
      setopt no_global_rcs
    '';

    shellAliases = {
      vi = "nvim";
      c = "clear";
      ls = "ls -A --color";
      fw = "cd $(git worktree list | fzf | awk '{print $1;}') || :";
      nd = "nix develop --command zsh";
    };

    initExtraFirst = ''
      setopt prompt_subst
      autoload -Uz vcs_info
      zstyle ':vcs_info:git:*' formats ' %b'
      precmd() { vcs_info }
      PS1='%F{blue}%~%f''${vcs_info_msg_0_} %# '
    '';

    initExtra = ''
      # loading plugins like this is much faster for some reason ???
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      ### mutable extra config
      [ -f $HOME/.zshrc.local ] && source "$HOME/.zshrc.local"
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
