{ writeShellScriptBin, pkgs}:
# a wrapper script that aborts if smart card is not inserted
writeShellScriptBin "withsc" ''
  if ${pkgs.gnupg}/bin/gpg --card-status &>/dev/null; then
    "$@"
  else
    # ${pkgs.libnotify}/bin/notify-send "$1 $2 ..." "no smartcard" &>/dev/null
    exit 1  
  fi
''
