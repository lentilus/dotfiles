{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  sshConfigDir = "${config.home.homeDirectory}/.ssh";
in {
  # sadly not very declaritive, but way too many applications
  # still write to the ssh config directly, so we need to make
  # it "mutable" :{

  # -> we just leave the config file alone and add a declared hm_config
  # The user is then required to add "Include hm_config" in their config
  # file. We try to remind them of that.

  home.file."${sshConfigDir}/hm_config" = {
    text = ''
      Host *
        ForwardAgent yes
        AddKeysToAgent no
        Compression no
        ServerAliveInterval 0
        ServerAliveCountMax 3
        HashKnownHosts no
        UserKnownHostsFile ${sshConfigDir}/known_hosts
        ControlMaster no
        ControlPath ~/.ssh/master-%r@%n:%p
        ControlPersist no

      Host github.com
        HostName github.com
        IdentityFile ${sshConfigDir}/github
    '';
    onChange = ''
      res=$(cat ${sshConfigDir}/config | grep "Include hm_config")
      if [ -z "$res" ]; then
          echo "WARNING: ssh config we generated is not being sourced!  (Use Include) "
      else
         echo "ssh config looks fine"
      fi
    '';
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
}
