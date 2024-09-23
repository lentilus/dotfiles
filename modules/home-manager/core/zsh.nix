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
      # absoulte basic gnu core utils
      pkgs.coreutils

      pkgs.locale
      # pkgs.glibcLocales
      pkgs.git
      pkgs.zsh
      pkgs.fzf
    ];

    # shell
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "viins"; # nice vim mode

      shellAliases = {
        vi = "nvim";
        c = "clear";
        ls = "ls -A --color";
        sw = "cd $(git worktree list | fzf | awk '{print $1;}')";
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
        fpath+=(${pkgs.pure-prompt}/share/zsh/site-functions)
        autoload -U promptinit; promptinit
        prompt pure
      '';

      initExtra = ''
        path+="$HOME/.local/scripts"
      '';
    };

    programs.zoxide.enable = true;
    programs.pyenv.enable = true;
  };
}
