# originally by: dermetfan (https://git.sr.ht/~dermetfan/home-manager-shell)
# modified by: lentilus
{
  home-manager,
  pkgs,
  args ? {},
  modules ? [],
}: let
  lib = pkgs.lib;
  home = builtins.getEnv "HOME";
  user = builtins.getEnv "USER";
  minimal = {
    home.homeDirectory = home;
    home.username = user;
    home.stateVersion = with lib; versions.majorMinor version;
  };
  homeConfiguration = home-manager.lib.homeManagerConfiguration (lib.recursiveUpdate {
      inherit pkgs;
      modules = [minimal] ++ modules;
    }
    args);
in
  pkgs.writeShellApplication {
    name = "home-manager-shell";
    runtimeInputs = with pkgs; [proot jq findutils];
    text = ''
      activationPackage=${homeConfiguration.activationPackage}
      profileDirectory=${homeConfiguration.config.home.profileDirectory}

      function launch {
        declare -a prootArgs

        while read -r; do
          prootArgs+=(-b "$REPLY":"${home}/''${REPLY#"$activationPackage/home-files/"}")
        done < <(find "$activationPackage/home-files/" -not -type d)

        prootArgs+=(-b "$activationPackage/home-path":"$profileDirectory")

        __HM_SESS_VARS_SOURCED=
        #shellcheck disable=SC1091
        source "$activationPackage/home-path/etc/profile.d/hm-session-vars.sh"

        HOME="${home}"
        USER="${user}"

        PATH="$activationPackage/home-path/bin''${PATH:+:}''${PATH:-}"
        PATH="$activationPackage/home-path/sbin''${PATH:+:}''${PATH:-}"

        exec proot \
          -R / \
          -w "$PWD" \
          "''${prootArgs[@]}" \
          "$@"
      }

      if [[ -n $* ]]; then
        launch "$@"
      elif [[ -n "$SHELL" ]]; then
        launch "$SHELL"
      else
        launch
      fi
    '';
  }
