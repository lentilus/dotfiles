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
  picker = pkgs.writeShellScriptBin "mofi" ''
    #!/bin/bash

    # Create a temporary file to store the input and the selection
    inputfile=$(mktemp)
    tempfile=$(mktemp)

    # Write input to the temporary file
    cat <&0 | sed 's/\x1b\[[0-9;]*m//g' > "$inputfile"

    # Launch `fzf` in a new foot terminal window
    foot sh -c "fzf < $inputfile > $tempfile"

    # Wait for the foot process to complete
    wait

    # Retrieve the selection from the temporary file
    selected=$(cat "$tempfile")

    # Clean up the temporary files
    rm "$inputfile"
    rm "$tempfile"

    # Use the selected value
    if [ -n "$selected" ]; then
        echo "$selected"
    fi
  '';
in
  {
    enable = true;
    skhdConfig = ''
        cmd - a : open -a "kitty"
        cmd - s : open -a "qutebrowser" 
        cmd - d : open -a "Microsoft Teams"
    '';
  };



}
