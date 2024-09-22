{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.nix-daemon.enable = true;
  nixpkgs.hostPlatform = "aarch64-darwin";
  users.users."linuspreusser" = {
    name = "linuspreusser";
    home = "/Users/linuspreusser";
  };

  programs.zsh.enable = true;
  system.defaults.universalaccess.reduceMotion = true;

  # make macos usable xD
  services.skhd = let
    # a little rofi alternative
    picker = pkgs.writeShellScriptBin "mofi" ''
      #!/bin/bash

      inputfile=$(mktemp)
      tempfile=$(mktemp)

      cat <&0 | sed 's/\x1b\[[0-9;]*m//g' > "$inputfile"
      kitty sh -c "fzf < $inputfile > $tempfile"
      wait
      selected=$(cat "$tempfile")
      rm "$inputfile"
      rm "$tempfile"
      if [ -n "$selected" ]; then
          echo "$selected"
      fi
    '';
  in {
    enable = true;
    skhdConfig = ''
      cmd - a : open -a "kitty"
      cmd - s : open -a "qutebrowser"
      cmd - d : open -a "Microsoft Teams"
    '';
  };
}
