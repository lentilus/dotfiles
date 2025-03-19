{pkgs, ...}: {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        # we execute with zsh so the sway process has the hm env
        command = ''${pkgs.zsh}/bin/zsh -c "${pkgs.sway}/bin/sway &> /tmp/sway.log"'';
        user = "lentilus";
      };
      default_session = initial_session;
    };
  };
}
