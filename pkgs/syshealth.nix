{writeShellScriptBin}:
writeShellScriptBin "syshealth" ''
  system_failed=$(systemctl --failed --no-legend --plain | wc -l)
  user_failed=$(systemctl --user --failed --no-legend --plain | wc -l)
  echo "$user_failed:$system_failed"
''
