{
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    pkgs.coreutils
    pkgs.locale
    pkgs.fzf
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

    localVariables = {
      # renders ambigous multi-key commands inaccessible
      KEYTIMEOUT = 1;
    };

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
      np = "nix-shell --command zsh -p";
    };

    initContent = lib.mkBefore ''
      setopt prompt_subst
      autoload -Uz vcs_info
      zstyle ':vcs_info:git:*' formats ' %b'
      precmd() { vcs_info }
      PS1='%F{blue}%~%f''${vcs_info_msg_0_} %# '

      # loading plugins like this is much faster for some reason ???
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      # V to open command in editor
      autoload edit-command-line; zle -N edit-command-line

      # https://stackoverflow.com/questions/16730650/zsh-how-to-backspace-through-to-the-previous-line
      bindkey -v '^?' backward-delete-char

      # vv does not work for KEYTIMEOUT=1
      bindkey -M vicmd 'V' edit-command-line

      ### mutable extra config
      [ -f $HOME/.zshrc.local ] && source "$HOME/.zshrc.local"
    '';
  };

  home.sessionPath = [
    "$HOME/.local/bin" # pipx
  ];
}
