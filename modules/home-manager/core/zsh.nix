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
    ];

    # shell
    programs.zsh = {
      enable = true;
      enableCompletion = false; # we manage it ourselves
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      # defaultKeymap = "viins"; # nice vim mode

      shellAliases = {
        vi = "nvim";
        c = "clear";
        ls = "ls -A --color";
        fw = "cd $(git worktree list | fzf | awk '{print $1;}')";
      };

      plugins = [
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "v1.1.2";
            sha256 = "sha256-Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
          };
        }
      ];

      initExtraFirst = ''
        # profiling
        # zmodload zsh/zprof

        # prompt
        setopt prompt_subst
        autoload -Uz vcs_info
        precmd() { vcs_info }
        zstyle ':vcs_info:git:*' formats '(%b)'
        PROMPT='%F{blue}%~%f ''${vcs_info_msg_0_} > '

        # load completions every 24 hours
        # https://gist.github.com/ctechols/ca1035271ad134841284
        autoload -Uz compinit
        if [[ -n ''${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
            compinit;
        else
            compinit -C;
        fi;
      '';

      initExtra = ''
        # for quick hotfix situations
        [ -f $HOME/.extrazsh ] && source "$HOME/.extrazsh"
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

        # zprof
      '';
    };

    programs.zoxide.enable = true;

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
